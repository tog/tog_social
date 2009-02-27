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

  # => oauth support
  has_many :client_applications
  has_many :tokens, :class_name=>"OauthToken", :order=>"authorized_at desc", :include=>[:client_application]
  # => oauth support

  def network
    profile.network.collect{|profile| profile.user}
  end
  
  protected

    def create_profile
      self.profile ||= Profile.new
    end

end
