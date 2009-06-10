class Membership < ActiveRecord::Base

  belongs_to :group
  belongs_to :user
  
  record_activity_of :user
  
  acts_as_state_machine :initial => :pending
  state :pending, :enter => :make_activation_code
  state :active, :enter => :do_activate
  state :invited
  event :activate do
    transitions :from => :pending, :to => :active
  end
  event :invite do
    transitions :from => :pending, :to => :invited
  end
  event :accept_invitation do
    transitions :from => :invited, :to => :active
  end
  
  def active?
    self.state == 'active'
  end
  
  protected  
  
  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end  
  
  def do_activate
    self.activated_at = Time.now.utc
    self.activation_code = nil
  end
  
end
