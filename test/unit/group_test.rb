require File.dirname(__FILE__) + '/../test_helper'

class GroupTest < Test::Unit::TestCase
  context "A Group" do
    
    setup do
      @berlusconi = Factory(:user, :login => 'berlusconi')
      @chavez = Factory(:user, :login => 'chavez')
      @pornfans = Factory(:group, :name => 'Porn without frontiers', :moderated => false, :author => @chavez)
    end

    should "should allow to join directly" do
      @pornfans.join(@berlusconi)
      assert @pornfans.members.include?(@berlusconi), "The joined user should be on the members list"
    end
    
    should "allow give moderator rights" do
      @pornfans.join(@berlusconi)
      assert_no_difference(Membership, :count) do
        @pornfans.grant_moderator(@berlusconi)
      end
      assert_contains @pornfans.moderators, @berlusconi
    end

    should "allow revoke moderator rights" do
      @pornfans.join(@berlusconi)
      assert_no_difference(Membership, :count) do
        @pornfans.revoke_moderator(@berlusconi)
      end
       assert_does_not_contain @pornfans.moderators, @berlusconi
    end
    
    context "that is moderated" do
      setup do
        @selectedporn = Factory(:group, :name => 'Porn for V.I.P', :moderated => true, :author => @chavez)
      end
    
      should "not allow to join directly" do
        assert_difference(Membership, :count) do
          @selectedporn.join(@berlusconi)
        end
        assert !@selectedporn.members.include?(@berlusconi)
        @selectedporn.activate_membership(@berlusconi)
        assert @selectedporn.members(true).include?(@berlusconi)
      end
    end
  
  end

end