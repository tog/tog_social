require File.dirname(__FILE__) + '/../test_helper'

class GroupSharingTest < ActiveSupport::TestCase
  
  context "A sharing" do

    setup do
      @sharing = Factory(:group_sharing)      
    end  
    
    should_validate_presence_of :group, :shared_by, :shareable
   
  end
  
end