class Group < ActiveRecord::Base
  
  acts_as_taggable      
  seo_urls      
  
  belongs_to :author, :class_name => 'User', :foreign_key => 'user_id'

  has_many :memberships

  has_many :moderator_memberships, :class_name => 'Membership',
                                   :conditions => ['memberships.moderator = ?', true]

  has_many :members,    :through => :memberships, :source => :user,
                        :conditions => ['memberships.state = ?', 'active']

  has_many :pending_members,  :through => :memberships, :source => :user,
                              :conditions => ['memberships.state = ?', 'pending']

  has_many :moderators, :through => :moderator_memberships, :source => :user,
                        :conditions => ['memberships.state = ?', 'active']


  file_column :image, :root_path => File.join(RAILS_ROOT, "public/system/group_photos"), :web_root => 'system/group_photos/', :magick => {
      :versions => {
        :big    => {:crop => "1:1", :size => Tog::Config["plugins.tog_social.group.image.versions.big"],    :name => "big"},
        :medium => {:crop => "1:1", :size => Tog::Config["plugins.tog_social.group.image.versions.medium"], :name => "medium"},
        :small  => {:crop => "1:1", :size => Tog::Config["plugins.tog_social.group.image.versions.small"],  :name => "small" },
        :tiny   => {:crop => "1:1", :size => Tog::Config["plugins.tog_social.group.image.versions.tiny"],   :name => "tiny"  }
      }
  }

  record_activity_of :user

  acts_as_state_machine :initial => :pending
  state :pending, :enter => :make_activation_code
  state :active,  :enter => :do_activate
  event :activate do
    transitions :from => :pending, :to => :active
  end

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :author

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



  protected
  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def do_activate
    self.activated_at = Time.now.utc
    self.activation_code = nil
    self.moderator_memberships.each{|mod| mod.activate!}
  end

end
