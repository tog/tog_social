class Member::SharingsController < Member::BaseController

  before_filter :find_group, :except => [:index]
#  before_filter :check_moderator, :except => [:index]

  def index
    @sharing = GroupSharing.new(:shareable_type => params[:shareable_type], :shareable_id => params[:shareable_id])
    @shareable = @sharing.shareable
    @groups = current_user.groups
    @referer = request.referer
    respond_to do |format|
     format.html
    end    
  end

  def share
    if @group.members.include? current_user
      if @group.share(current_user, params[:shareable_type], params[:shareable_id])
        message = I18n.t("tog_social.groups.site.shared_ok", :name => @group.name)
        html_class = 'notice ok'
      else
        message = I18n.t("tog_social.groups.site.shared_nok", :name => @group.name)
        html_class = 'notice'
      end
      respond_to do |format|
         format.html { render :text => "<div class=\"#{html_class}\">#{message}</div>"}
         format.xml  { render :xml => message, :head => :ok }
      end
    else
      respond_to do |format|
         format.html { render :text => "<div class=\"notice error\">#{I18n.t("tog_social.groups.site.not_member")}</div>"}
         format.xml  { render :xml => I18n.t("tog_social.groups.site.not_member"), :head => :error }
      end
    end
  end
  
  protected

    def find_group
      @group = Group.find(params[:id]) if params[:id]
    end

    def check_moderator
      unless @group.moderators.include? current_user
        flash[:error] = I18n.t("tog_social.groups.member.not_moderator") 
        redirect_to group_path(@group)
      end
    end

end