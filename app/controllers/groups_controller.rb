class GroupsController < ApplicationController
  
  before_filter :login_required, :only => [:join, :leave]   
  before_filter :load_group, :only => [:show, :join, :leave, :members, :invite_accept, :invite_reject] 
      
  def index
    @order = params[:order] || 'created_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'    
    @groups = Group.paginate :per_page => 10,
                             :page => @page,
                             :conditions => ['state = ? and private = ?', 'active', false],
                             :order => @order + " " + @asc 
    respond_to do |format|
      format.html
      format.rss { render(:layout => false) }
    end    
  end  
  
  def search
    @order = params[:order] || 'name'
    @page = params[:page] || '1'
    @search_term = params[:search_term]
    term = '%' + @search_term + '%'
    @asc = params[:asc] || 'asc'    
    @groups = Group.paginate :per_page => 10,
          :conditions => ["state=? and (name like ? or description like ?)", 
            'active', term, term],
          :page => @page,
          :order => @order + " " + @asc 
    respond_to do |format|
       format.html { render :template => "groups/index"}
       format.xml  { render :xml => @groups }
    end
  end
  
  def show
  end  
  
  def members
  end
  
      
  def tag
    @tag = params[:tag]
    @groups = Group.find_tagged_with(@tag, :conditions => ['state = ? and private = ?', 'active', false])
    respond_to do |format|
      format.html # tag.html.erb
      format.xml  { render :xml => @groups.to_xml }
    end       
  end  

  def join
    if @group.members.include? current_user
      flash[:notice] = 'You already are a member of this group.'
    else
      if @group.pending_members.include? current_user
        flash[:notice] = 'Your join request is already being processed. Please, be patient.'
      else      
        @group.join(current_user)
        if @group.moderated == true
          GroupMailer.deliver_join_request(@group, current_user)
          flash[:notice] = 'You request has been received. Moderators of this groups will make a decision soon.'
        else
          @group.activate_membership(current_user)
          flash[:notice] = 'Welcome to ' + @group.name + '. Enjoy it!'          
        end
      end
    end
    redirect_to group_url(@group)    
  end
   
  def leave
    if !@group.members.include?(current_user) && !@group.pending_members.include?(current_user)
      flash[:notice] = 'You are not a member of this group.'
    else
      if @group.moderators.include?(current_user) && @group.moderators.size == 1
        flash[:error] = "You are the last moderator of this group. You can't leave it before nominating a new moderator"
      else
        @group.leave(current_user)
        #todo: eliminar cuando este claro que sucede si un usuario ya es miembro
        flash[:notice] = 'You are no longer a member of this group'
      end
    end
    redirect_to member_groups_path
  end
  
  
  def invite_accept
    mem = Membership.find(params[:id])
    if mem
      group = mem.group
      if mem.user_id == current_user.id
        mem.group.activate_membership(current_user)
        flash[:notice] = 'Ahora formas parte de esta comunidad'
        subject = 'Invitación a la comunidad ' + group.name + ' aceptada'
        body = 'El usuario ' + current_user.name + ' ha aceptado ser parte de la comunidad.'
        send_message_to_moderators(group, current_user, subject, body)
        redirect_to groups_members_path(group)
      else
        flash[:error] = 'Esta invitación no es para tí'
        redirect_to groups_members_path(group)
      end
    else
      flash[:error] = 'No se ha encontrado esa invitación'
      redirect_to profiles_show_path(current_user)
    end
  end
  
  def invite_reject
    mem = Membership.find(params[:id])
    if mem
      group = mem.group
      if mem.user_id == current_user.id
        mem.destroy
        flash[:notice] = 'Has rechazado la invitación'
        subject = 'Invitación a la comunidad ' + group.name + ' rechazada'
        body = 'El usuario ' + current_user.name + ' ha rechazado ser parte de la comunidad.'
        send_message_to_moderators(group, current_user, subject, body)
        redirect_to groups_members_path(group)
      else
        flash[:error] = 'Esta invitación no es para tí'
        redirect_to groups_members_path(group)
      end
    else
      flash[:error] = 'No se ha encontrado esa invitación'
      redirect_to profiles_show_path(current_user)
    end    
  end
  
  private 
    def load_group
      #todo be more specific with this error control
      begin
        @group = Group.find(params[:id]) 
        raise "Error. This group is not active" unless @group.active?
      rescue 
        flash[:error] = "Error. This group is not active or doesn't exist"
        redirect_to groups_path 
      end
    end
    
    def send_message_to_moderators(group, user, subject, body)
      group.moderators.each do |moderator|
        message = Message.new(
          :from     => user,
          :to       => moderator,
          :subject  => subject,
          :content  => body)
        message.dispatch!   
      end      
    end
end
