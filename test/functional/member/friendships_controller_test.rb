require File.dirname(__FILE__) + '/../../test_helper'

class Member::FriendshipsControllerTest < ActionController::TestCase

  context "A logged user" do
    setup do
      @berlusconi = Factory(:user, :login => 'berlusconi')
      @berlusconi.activate!

      @chavez = Factory(:user, :login => 'chavez')
      @chavez.activate!
    end
    
    context "on POST to :add_friend" do
      setup do
        full_name=@chavez.profile.full_name
        @request.session[:user_id]= @berlusconi.id
        post :add_friend, :friend_id => @chavez.profile.id
      end
      
      should "follow to friend" do
        assert @berlusconi.profile.follows?(@chavez.profile) 
      end
      
      should "send an info message" do
        assert_equal 1, @chavez.inbox.messages.count
        assert_equal I18n.t("tog_social.friendships.member.mail.add_friend.subject", :user_name => @berlusconi.profile.full_name), @chavez.inbox.messages.first.subject
      end

      should_set_the_flash_to I18n.t("tog_social.friendships.member.friend.added", :friend_name => "chavez")
    end
    
    context "on POST to :confirm_friend" do
      setup do
        @chavez.profile.add_follower(@berlusconi.profile)
        @request.session[:user_id]= @chavez.id
        post :confirm_friend, :friend_id => @berlusconi.profile.id
      end
      
      should "be friends" do
        assert @chavez.profile.is_friend_of?(@berlusconi.profile) 
      end
      
      should "send an confirmation message" do
        assert_equal 1, @berlusconi.inbox.messages.count
        assert_equal I18n.t("tog_social.friendships.member.mail.confirm_friend.subject", :user_name => @chavez.profile.full_name), @berlusconi.inbox.messages.first.subject
      end
      
      should_set_the_flash_to I18n.t("tog_social.friendships.member.friend.confirmed", :friend_name => "berlusconi")
    end
  end
end