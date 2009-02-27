class Group < ActiveRecord::Base

  belongs_to :author, :class_name => 'User', :foreign_key => 'user_id'

  has_many :memberships, :dependent => :destroy

  has_many :moderator_memberships, :class_name => 'Membership',
                                   :conditions => ['memberships.moderator = ?', true]

  has_many :members,    :through => :memberships, :source => :user,
                        :conditions => ['memberships.state = ?', 'active']

  has_many :pending_members,  :through => :memberships, :source => :user,
                              :conditions => ['memberships.state = ?', 'pending']

  has_many :moderators, :through => :moderator_memberships, :source => :user,
                        :conditions => ['memberships.state = ?', 'active']
                        
  has_many :sharings, :class_name => 'GroupSharing'

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :author

  before_create :set_default_image

  has_attached_file :image, {
    :url => "/system/:class/:attachment/:id/:style_:basename.:extension",
    :styles => { 
      :big    => Tog::Plugins.settings(:tog_social, "group.image.versions.big"),
      :medium => Tog::Plugins.settings(:tog_social, "group.image.versions.medium"),
      :small  => Tog::Plugins.settings(:tog_social, "group.image.versions.small"),
      :tiny   => Tog::Plugins.settings(:tog_social, "group.image.versions.tiny")
    }}.merge(Tog::Plugins.storage_options)

  record_activity_of :author
  acts_as_abusable
  acts_as_taggable
  seo_urls

  acts_as_state_machine :initial => :pending
  state :pending, :enter => :make_activation_code
  state :active,  :enter => :do_activate
  event :activate do
    transitions :from => :pending, :to => :active
  end
  
  named_scope :active, :conditions => {:state => 'active'}
  
  def self.site_search(query, search_options={})
    Group.active.find(:all, :conditions => ["name like ?", "%#{query}%"])
  end

  def membership_of(user)
    mem = memberships.select{|m| m.user == user}
    return mem.first unless mem.blank?
  end

  def activate_membership(user)
    mem = membership_of(user)
    mem.activate! if mem && mem.pending?
  end

  def grant_moderator(user)
    moderator_privileges(user,true)
  end

  def revoke_moderator(user)
    moderator_privileges(user,false)
  end

  def moderator_privileges(user, grant=false)
    mem = membership_of(user)
    mem.moderator = grant
    mem.save!
  end

  def join(user,moderator=false)
    # todo Confirm what to do if th user is already a member. By now just ignore it and continue.
    mem = membership_of(user)
    mem = self.memberships.build(:user => user, :moderator => moderator) unless mem
    mem.save!
    grant_moderator(user) if moderator
    mem.activate! unless self.moderated?
  end

  def leave(user)
    mem = membership_of(user)
    mem.destroy if mem
  end

  def is_banned(user)
    raise "Implement this..."
  end

  def ban(user)
    raise "Implement this..."
  end

  def share(user, shareable_type, shareable_id)
    params = {:shareable_type => shareable_type, :shareable_id => shareable_id} 
    return false if self.sharings.find :first, :conditions => params
    self.sharings.create params.merge!({:shared_by => user})
    return true
  end
  
  def creation_date(format=:short)
    I18n.l(self.created_at, :format => format)
  end

  protected
  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def do_activate
    self.activated_at = Time.now.utc
    self.activation_code = nil
    self.moderator_memberships.each{|mod| mod.activate!}
  end

  def set_default_image
    unless self.image?
      if Tog::Config["plugins.tog_social.group.image.default"]
        default_group_image = File.join(RAILS_ROOT, 'public', 'tog_social', 'images', Tog::Config["plugins.tog_social.group.image.default"])
        self.image = File.new(default_group_image)
      end
    end
  end

end
