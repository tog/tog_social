class Membership < ActiveRecord::Base

  belongs_to :group
  belongs_to :user
  
  record_activity_of :user
  
  include AASM
  aasm_column :state
  aasm_initial_state :pending
  aasm_state :pending, :enter => :make_activation_code
  aasm_state :active, :enter => :do_activate
  aasm_state :invited
  
  aasm_event :activate do
    transitions :from => :pending, :to => :active
  end
  aasm_event :invite do
    transitions :from => :pending, :to => :invited
  end
  aasm_event :accept_invitation do
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
