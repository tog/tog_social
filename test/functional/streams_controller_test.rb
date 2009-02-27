require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'

class StreamsControllerTest < ActionController::TestCase

  should_route :get, "/streams", :controller => "streams", :action => "index"
  should_route :get, "/streams.rss", :controller => "streams", :action => "index", :format => :rss
  should_route :get, "/streams/1", :controller => "streams", :action => "show",  :id => "1"
  

  context "The activities controller" do
    setup do
      @group = Factory(:group)
      
      @fidel = Factory(:user, :login => "fidel")
      @act = Factory(:activity, :user => @fidel, :action => "create", :item => @group)
      @evo = Factory(:user, :login => "evo")
      @act_evo = Factory(:activity, :user => @evo, :action => "moderate", :item => @group)
      
      @fidel.stubs(:network).returns([@evo])
      User.stubs(:find).returns(@fidel)
      Activity.stubs(:created_since).returns([@act_evo, @act])
    end
    

    ['rss', 'html'].each{|format|
      context "viewing activity of all users via #{format}" do
        setup do
          get :index, :format => format
        end
        should_respond_with :success
        should_respond_with_content_type format.to_sym
        should_assign_to :activities
        should "list all activities" do
          assert_equal assigns(:activities), [@act_evo, @act]
        end
      end
      context "viewing activity of an user's network via #{format} " do
        setup do
          get :network, :id => @fidel, :format => format
        end
        
        should_respond_with :success
        should_respond_with_content_type format.to_sym
        should_assign_to :activities
        
        should "list user and friends activities" do
          assert_contains assigns(:activities), @act_evo
          assert_does_not_contain assigns(:activities), @act
        end
      end
      
      context "viewing activity of an user via #{format} " do
        setup do
          get :show, :id => @fidel, :format => format
        end
      
        should_respond_with :success
        should_respond_with_content_type format.to_sym
        should_assign_to :activities, :class => Array
        
        should "list only user's activities" do
          assigns(:activities).each { |activity| 
            assert_equal(@fidel, activity.user)
          }
          assert_contains(assigns(:activities), @act)
        end
      end
    }


  end
end