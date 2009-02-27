class GroupsController < ApplicationController

  before_filter :login_required, :only => [:join, :leave]
  before_filter :load_group, :only => [:show, :join, :leave, :members, :invite_accept, :invite_reject, :share]

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
      flash[:notice] = I18n.t("tog_social.groups.site.already_member")
    else
      if @group.pending_members.include? current_user
        flash[:notice] = I18n.t("tog_social.groups.site.request_waiting")
      else
        @group.join(current_user)
        if @group.moderated == true
          GroupMailer.deliver_join_request(@group, current_user)
          flash[:ok] = I18n.t("tog_social.groups.site.request_received")
        else
          @group.activate_membership(current_user)
          flash[:ok] = I18n.t("tog_social.groups.site.welcome", :name => @group.name)
        end
      end
    end
    redirect_to group_url(@group)
  end

  def leave
    if !@group.members.include?(current_user) && !@group.pending_members.include?(current_user)
      flash[:error] = I18n.t("tog_social.groups.site.not_member")
    else
      if @group.moderators.include?(current_user) && @group.moderators.size == 1
        flash[:error] = I18n.t("tog_social.groups.site.last_moderator")
      else
        @group.leave(current_user)
        #todo: eliminar cuando este claro que sucede si un usuario ya es miembro
        flash[:ok] = I18n.t("tog_social.groups.site.leaved")
      end
    end
    redirect_to member_groups_path
  end

  private
    def load_group
      #TODO be more specific with this error control
      begin
        @group = Group.find(params[:id])
        raise I18n.t("tog_social.site.groups.unactive") unless @group.active?
      rescue
        flash[:error] = I18n.t("tog_social.groups.site.not_found")
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
