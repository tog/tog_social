class Admin::GroupsController < Admin::BaseController
      
  def index
    @order = params[:order] || 'name'
    @page = params[:page] || '1'
    @groups = Group.paginate :per_page => 20,
                             :page => @page,
                             :order => "#{@order} ASC"    
  end  
  
  def show
    @group = Group.find(params[:id])  
  end  
    
  
 
  
end