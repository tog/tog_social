class Member::GroupsController < Member::BaseController
  
  before_filter :find_group, :only => [:edit, :update, :pending, :reject, :accept, :pending_links, :reject_link, :accept_link]
  before_filter :check_moderator, :only => [:edit, :update, :pending, :reject, :accept, :pending_links, :reject_link, :accept_link]
        
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
         flash[:notice] = 'Group created successfully.'
         redirect_to group_path(@group)
      else
        GroupMailer.deliver_activation_request(@group)
        flash[:notice] = 'Your group has been created but is pending for administration approval.'
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
    flash[:notice] = "Group #{@group.name} succcessfully updated!"     
    redirect_to groups_show_path(@group)   
  end
  
  def pending_members
  end
  
  def reject
    user = User.find(params[:user_id])
    if !user
      flash[:error] = 'No existe ese usuario'
      redirect_to groups_show_path(@group)
      return
    end
    @group.leave(user)
    if @group.membership_of(user)
      GroupMailer.deliver_reject_join_request(@group, current_user, user)
      flash[:notice] = "El usuario " + user.name + " ha sido rechazado de la comunidad"
    else
      flash[:error] = "Ha ocurrido un error al proceder a la denegación"
    end
    redirect_to groups_pending_members_path(@group)    
  end
  def accept
    user = User.find(params[:user_id])
    if !user
      flash[:error] = 'No existe ese usuario'
      redirect_to groups_show_path(@group)
      return
    end    
    @group.activate_membership(user)
    if @group.members.include? user
        GroupMailer.deliver_accept_join_request(@group, current_user, user)
        flash[:notice] = "El usuario " + user.name + " ha sido añadido a la comunidad"
    else
      flash[:error] = "Ha ocurrido un error al proceder a la aceptación"
    end
    redirect_to groups_pending_members_path(@group) 
  end  
  
  def invite_send
    user = User.find(params[:user_id])

    params[:community].each do |comm_id|
      group = Group.find(comm_id)
      if group.moderators.include?(current_user)
        group.join(user, false)
        GroupMailer.deliver_invitation(group, current_user, user)
      end
      flash[:notice] = 'Se han enviado las invitaciones'
    end  
    redirect_to profiles_show_path(user.id)
  end
  
  def change_role_community
    comunity = Group.find(params[:id])
    profile = Profile.find(params[:profileid])
    member = comunity.membership_of(profile.user)
    if(member && !profile.user.child)
      if(params[:active]=='1')
        member.moderator=true
        member.save()
        active=0
        msg = 'Quitar rol de moderador'
      else
        member.moderator=false
        member.save()
        active=1
        msg = 'Asignar rol de moderador'
      end
      render :update do |page|    
        page.replace_html 'changerol'+params[:profileid] , link_to_remote(msg, :url => groups_change_role_path(comunity,profile.id,active), :html=> {:class =>'maincolor5'})      
      end
    end
  end
  
  protected


  def find_group
    @group = Group.find(params[:id]) if params[:id]
  end

  def check_moderator
    unless @group.moderators.include? current_user
      flash[:error] = "No eres un moderador de esta comunidad."
      redirect_to groups_show_path(@group)
    end
  end  
  
end