require File.dirname(__FILE__) + '/../test_helper'

class GroupsControllerTest < ActionController::TestCase

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
        should_set_the_flash_to I18n.t("tog_social.groups.site.welcome", :name => 'Porn without frontiers')
        should_redirect_to ("PornFans") { group_url(@pornfans) }
      end
      context "when a invited user" do
        setup do
          @pornfans.invite(@berlusconi)
        end
      
        context "accept invitation" do
          setup do
            get :accept_invitation, :id => @pornfans.id 
          end
          should_set_the_flash_to I18n.t("tog_social.groups.site.invite.invitation_accepted")
          should_redirect_to ("the group's page"){ group_path(@pornfans) }
        end
      
        context "reject invitation" do
          setup do      
            get :reject_invitation, :id => @pornfans.id
          end
          should_set_the_flash_to I18n.t("tog_social.groups.site.invite.invitation_rejected")      
          should_redirect_to ("the group's page"){ group_path(@pornfans) }
        end
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
        should_set_the_flash_to I18n.t("tog_social.groups.site.request_received")
        should_redirect_to ("PornFans") { group_url(@pornfans) }
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
