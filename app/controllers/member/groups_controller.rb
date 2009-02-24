class Member::GroupsController < Member::BaseController

  before_filter :find_group, :except => [:index, :new, :create]
  before_filter :check_moderator, :except => [:index, :new, :create]

  def index
    @moderator_memberships = current_user.moderator_memberships
    @plain_memberships = current_user.plain_memberships
  end

  def create
    @group = Group.new(params[:group])
    @group.author = current_user
    @group.save

    @group.join(current_user, true)
    @group.activate_membership(current_user)

    if @group.errors.empty?
      if current_user.admin == true || Tog::Config['plugins.tog_social.group.moderation.creation'] != true
         @group.activate!
         flash[:ok] = I18n.t("tog_social.groups.member.created")
         redirect_to group_path(@group)
      else

        admins = User.find_all_by_admin(true)        
        admins.each do |admin|
          Message.new(
            :from => current_user,
            :to   => admin,
            :subject => I18n.t("tog_social.groups.member.mail.activation_request.subject", :group_name => @group.name),
            :content => I18n.t("tog_social.groups.member.mail.activation_request.content", 
                               :user_name   => current_user.profile.full_name, 
                               :group_name => @group.name, 
                               :activation_url => edit_admin_group_url(@group)) 
          ).dispatch!     
        end

        flash[:warning] = I18n.t("tog_social.groups.member.pending")
        redirect_to groups_path
      end
    else
      render :action => 'new'
    end

  end

  def update
    @group.update_attributes!(params[:group])
    @group.tag_list = params[:group][:tag_list]
    @group.save
    flash[:ok] =  I18n.t("tog_social.groups.member.updated", :name => @group.name) 
    redirect_to group_path(@group)
  end

  def reject_member
    user = User.find(params[:user_id])
    if !user
      flash[:error] = I18n.t("tog_social.groups.member.user_doesnot_exists")
      redirect_to pending_members_paths(@group)
      return
    end
    @group.leave(user)
    if @group.membership_of(user)
      GroupMailer.deliver_reject_join_request(@group, current_user, user)
      flash[:ok] = I18n.t("tog_social.groups.member.user_rejected", :name => user.profile.full_name) 
    else
      flash[:error] = I18n.t("tog_social.groups.member.error") 
    end
    redirect_to member_group_pending_members_url(@group)
  end

  def accept_member
    user = User.find(params[:user_id])
    if !user
      flash[:error] = I18n.t("tog_social.groups.member.user_doesnot_exists")
      redirect_to pending_members_paths(@group)
      return
    end
    @group.activate_membership(user)
    if @group.members.include? user
      GroupMailer.deliver_accept_join_request(@group, current_user, user)
      flash[:ok] = I18n.t("tog_social.groups.member.user_accepted", :name => user.profile.full_name)
    else
      flash[:error] = I18n.t("tog_social.groups.member.error") 
    end
    redirect_to member_group_pending_members_url(@group)
  end



  protected


  def find_group
    @group = Group.find(params[:id]) if params[:id]
  end

  def check_moderator
    unless @group.moderators.include? current_user
      flash[:error] = I18n.t("tog_social.groups.member.not_moderator") 
      redirect_to groups_path(@group)
    end
  end

end