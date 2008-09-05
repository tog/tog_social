class User < ActiveRecord::Base


  before_create :create_profile

  has_one :profile, :dependent => :destroy
  has_many :memberships
  has_many :plain_memberships, :class_name => 'Membership', 
                               :conditions => ['memberships.moderator <> ?', true]
  has_many :moderator_memberships, :class_name => 'Membership', 
                                   :conditions => ['memberships.moderator = ?', true]

  has_many :groups, :through => :memberships, 
                    :conditions => "memberships.state='active' and groups.state='active'"

  has_many :moderated_groups, :through => :moderator_memberships, 
                    :conditions => "memberships.state='active' and groups.state='active'", :source => :group

  def name
      profile.full_name
  end
  
  protected

    def create_profile
      self.profile ||= Profile.new
    end

end
