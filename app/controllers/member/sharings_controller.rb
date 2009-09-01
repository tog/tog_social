class Member::SharingsController < Member::BaseController

  before_filter :find_group, :except => [:index, :new]

  def index
    @order = params[:order] || 'created_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'
    @sharings = current_user.sharings.paginate  :per_page => 10,
                                                :page => @page,
                                                :order => "#{@order} #{@asc}"    
    respond_to do |format|
     format.html
    end    
  end

  def new
    @sharing = Share.new(:shareable_type => params[:shareable_type], :shareable_id => params[:shareable_id])
    @shareable = @sharing.shareable
    @groups = current_user.groups
    @referer = request.referer
    respond_to do |format|
     format.html
    end    
  end

  def create
    if @group.members.include? current_user
      if @group.share(current_user, params[:shareable_type], params[:shareable_id])
        flash[:ok] = I18n.t("tog_social.sharings.member.shared_ok", :name => @group.name)
      else
        flash[:notice] = I18n.t("tog_social.sharings.member.shared_nok", :name => @group.name)
      end
    else
      flash[:error] = I18n.t("tog_social.sharings.member.not_member", :name => @group.name)
    end
    respond_to do |format|
       format.html { redirect_to :back }
       format.xml  { render :xml => message, :head => :ok }
    end    
    
  end

  def destroy
    @sharing = @group.sharings.find params[:id]
    if @sharing && (@sharing.user == current_user || @group.moderators.include?(current_user) )
      @sharing.destroy         
      flash[:ok] = I18n.t("tog_social.sharings.member.remove_share_ok", :name => @group.name)
    else
      flash[:ok] = I18n.t("tog_social.sharings.member.remove_share_nok", :name => @group.name)      
    end
    respond_to do |format|
      format.html { redirect_to member_sharings_path }
      format.xml
    end    
  end


  protected

    def find_group
      @group = Group.find(params[:group_id]) if params[:group_id]      
    end

end
