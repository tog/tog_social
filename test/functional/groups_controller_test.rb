require File.dirname(__FILE__) + '/../test_helper'

class GroupsControllerTest < Test::Unit::TestCase

  context "A regular user" do
    setup do
      @controller = GroupsController.new
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new

      @berlusconi = Factory(:user, :login => 'berlusconi')
      @berlusconi.activate!
      @chavez = Factory(:user, :login => 'chavez')
      @chavez.activate!
      @request.session[:user_id]= @berlusconi.id
    end
    
    context "in a non-moderated group" do
      setup do
        @pornfans = a_group
      end
      
      context "when joining" do
        setup do
          get :join, :id => @pornfans
        end
        should_set_the_flash_to /Welcome to the group 'Porn without frontiers'. Enjoy your participation!/i
        should_redirect_to "group_url(@pornfans)"
      end
    end
    
    context "in a moderated group" do
      setup do
        @pornfans = a_group(true)
      end
      
      context "when joining" do
        setup do
          get :join, :id => @pornfans
        end
        should_set_the_flash_to /You request has been received. Moderators of this group will make a decision soon./i
        should_redirect_to "group_url(@pornfans)"
        should "send an email to the group's admin" do
          assert_sent_email do |email|
            email.subject =~ /Request for joining Porn without frontiers/ &&
            email.to.include?(@chavez.email)
          end
        end
      end
    end
    
    
  end
  def a_group(moderated=false,activate=true)
    @pornfans = Factory(:group, :name => 'Porn without frontiers', :moderated => moderated, :author => @chavez)
    @pornfans.activate! if activate
    @pornfans
  end
end