require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class Member::SharingsControllerTest < ActionController::TestCase
  
  context "A logged user" do
    setup do
      @controller = Member::SharingsController.new
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new
            
      @berlusconi = create_active_user('berlusconi')
      @request.session[:user_id]= @berlusconi.id      

      @referer = "http://www.google.es"
      @request.env["HTTP_REFERER"] = @referer

      @pornfans = Factory(:group, :name => 'Porn without frontiers', :moderated => false, :author => @berlusconi)
    end
    
    context "can GET his sharings" do
      setup do
        @pornfans.join(@berlusconi, true)
        @sharing = @pornfans.share(@berlusconi, @berlusconi.profile.class.to_s, @berlusconi.profile.id)
        get :index
      end 
    
      should_assign_to :sharings
      
      should "include all his sharings" do
        assert assigns(:sharings).include?(@sharing) 
      end      
    end

    context "member of a group" do
      setup do
        @pornfans.join(@berlusconi, true)
      end

      context "on POST to :create" do
        setup do
          post :create, :group_id => @pornfans.id, :shareable_type => @berlusconi.profile.class.to_s, :shareable_id => @berlusconi.profile.id
        end

        should "share the object with the group" do
          assert @pornfans.shared?(@berlusconi.profile) 
        end
        
        should_set_the_flash_to /Object shared/i      
        should_redirect_to(":back") { @referer }
        
      end
      
      context "on POST to :create for an already shared object" do
        setup do
          @pornfans.share(@berlusconi, @berlusconi.profile.class.to_s, @berlusconi.profile.id)
          post :create, :group_id => @pornfans.id, :shareable_type => @berlusconi.profile.class.to_s, :shareable_id => @berlusconi.profile.id
        end

        should "share the object with the group" do
          assert @pornfans.shared?(@berlusconi.profile) 
        end
        
        should_set_the_flash_to /already shared/i      
        should_redirect_to(":back") { @referer }
        
      end
            
      context "on delete" do
        setup do
          @sharing = @pornfans.share(@berlusconi, @berlusconi.profile.class.to_s, @berlusconi.profile.id)
          delete :destroy, :group_id => @pornfans.id, :id => @sharing.id
        end

        should "remove the object from the group" do
          assert !@pornfans.shared?(@berlusconi.profile) 
        end
        
        should_set_the_flash_to /removed successfully/i      
        should_redirect_to("sharings index") { member_sharings_path }
      end      
    end
        
    context "not member of a group" do
      setup do
        @chavez = Factory(:user, :login => 'chavez')
        @chavez.activate!
        @request.session[:user_id]= @chavez.id        
      end

      context "on POST to :create" do
        setup do
          post :create, :group_id => @pornfans.id, :shareable_type => @berlusconi.profile.class.to_s, :shareable_id => @berlusconi.profile.id
        end

        should "not share the object with the group" do
          assert !@pornfans.shared?(@berlusconi.profile) 
        end

        should_set_the_flash_to /have to be member/i      
        should_redirect_to(":back") { @referer }
        
      end 
      
      context "on delete" do
        setup do
          @sharing = @pornfans.share(@berlusconi, @berlusconi.profile.class.to_s, @berlusconi.profile.id)
          delete :destroy, :group_id => @pornfans.id, :id => @sharing.id
        end

        should "not remove the object from the group" do
          assert @pornfans.shared?(@berlusconi.profile) 
        end
        
        should_set_the_flash_to /not removed/i      
        should_redirect_to("sharings index") { member_sharings_path }
      end           
    end
        
  end  
  
end
