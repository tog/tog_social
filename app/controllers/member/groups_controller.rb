class Member::GroupsController < Member::BaseController
  
  helper :groups
  
  before_filter :find_group, :except => [:index, :new, :create]
  before_filter :check_moderator, :except => [:index, :new, :create]
     
  def index
    @moderator_memberships = current_user.moderator_memberships
    @plain_memberships = current_user.plain_memberships
  end
     
  def new
  end  
  
  def create
    @group = Group.new(params[:group])
    @group.author = current_user
    @group.save
    
    @group.join(current_user, true)
    @group.activate_membership(current_user)
        
    if @group.errors.empty?
      if current_user.admin == true || Tog::Config['plugins.tog_social.group.moderation.creation'] != 'true'
         @group.activate!
         flash[:ok] = 'Group created successfully.'
         redirect_to group_path(@group)
      else
        GroupMailer.deliver_activation_request(@group)
        flash[:warning] = 'Your group has been created but is pending for administration approval.'
        redirect_to groups_path          
      end      
    else
      render :action => 'new'
    end    

  end
  
  def edit
  end
  
  def update
    @group.update_attributes!(params[:group])
    @group.tag_list = params[:group][:tag_list]
    @group.save
    flash[:ok] = "Group #{@group.name} succcessfully updated!"     
    redirect_to groups_show_path(@group)   
  end
  
  def pending_members
  end
  
  def reject_member
    user = User.find(params[:user_id])
    if !user
      flash[:error] = "User doesn't exist"
      redirect_to pending_members_paths(@group)
      return
    end
    @group.leave(user)
    if @group.membership_of(user)
      GroupMailer.deliver_reject_join_request(@group, current_user, user)
      flash[:ok] = "User " + user.name + " has been rejected for this group"
    else
      flash[:error] = "Ooops. something happened."
    end
    redirect_to member_group_pending_members_url(@group)    
  end
  
  def accept_member
    user = User.find(params[:user_id])
    if !user
      flash[:error] = "User doesn't exist"
      redirect_to pending_members_paths(@group)
      return
    end    
    @group.activate_membership(user)
    if @group.members.include? user
        GroupMailer.deliver_accept_join_request(@group, current_user, user)
      flash[:ok] = "User " + user.name + " has been accepted in this group"
    else
      flash[:error] = "Ooops. something happened."
    end
    redirect_to member_group_pending_members_url(@group) 
  end  
  

  
  protected


  def find_group
    @group = Group.find(params[:id]) if params[:id]
  end

  def check_moderator
    unless @group.moderators.include? current_user
      flash[:error] = "You are not one of this group's moderators."
      redirect_to groups_path(@group)
    end
  end  
  
end