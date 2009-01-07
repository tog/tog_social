require File.dirname(__FILE__) + '/../test_helper'

class ProfilesControllerTest < Test::Unit::TestCase

  context "on GET to :index" do
    setup do
      @controller = ProfilesController.new
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new

      @user = Factory(:user, :login => 'chavez')
      @user.activate!  
      @user2 = Factory(:user, :login => 'evo')  

      @chavez = Factory(:profile, :first_name => 'Hugo', :last_name => 'Chavez', :user => @user)
      @evo = Factory(:profile, :first_name => 'Evo', :last_name => 'Morales', :user => @user2)
      
      get :index
    end

    should_assign_to :profiles

    should_respond_with :success
    should_render_template :index

    should "list only active users" do
      assert  assigns(:profiles).include?(@chavez), "Active users should be on the profiles list"
      assert !assigns(:profiles).include?(@evo),    "Not active users should not be on the profiles list"
    end
  end
end