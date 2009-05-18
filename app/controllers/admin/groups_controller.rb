class Admin::GroupsController < Admin::BaseController

  def index
    @order = params[:order] || 'name'
    @page = params[:page] || '1'
    @groups = Group.paginate :per_page => 20,
                             :page => @page,
                             :order => "#{@order} ASC"
  end

  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(params[:group])
    @group.author = current_user
    if @group.save
      flash[:ok] = I18n.t("tog_social.groups.message.creation_successful")
      redirect_to admin_groups_path      
    else
      flash[:error] = I18n.t("tog_social.groups.message.creation_failed")
      render :action => "new"
    end
  end
  
  def edit
    @group = Group.find(params[:id])
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    respond_to do |wants|
      wants.html do
        flash[:ok]= I18n.t("tog_social.groups.admin.deleted")
        redirect_to admin_groups_path
      end
    end
  end

  def activate
    @group = Group.find(params[:id])
    @group.activate!
    respond_to do |wants|
      if @group.activate!
        wants.html do
          render :text => "<span>#{I18n.t("tog_social.groups.admin.activated")}</span>"
        end
      end
    end
  end

end