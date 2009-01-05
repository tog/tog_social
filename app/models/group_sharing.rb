class GroupSharing  < ActiveRecord::Base
   belongs_to :group
   belongs_to :shared_by, :class_name => 'User', :foreign_key => 'shared_by'   
   belongs_to :shareable, :polymorphic => 'true'
   
   named_scope :accepted, :conditions => ['status = ?', 1]
   named_scope :pending, :conditions => ['status = ?', 0]
   
   PENDING  = 0
   ACCEPTED = 1
   
   
end