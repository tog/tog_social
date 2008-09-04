class ProfilesController < ApplicationController
  
  def index
    @order = params[:order] || 'created_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'   
    @profiles = Profile.paginate :per_page => Tog::Config["plugins.tog_social.profile.list.page.size"],
                                 :page => @page,
                                 :order => @order + " " + @asc 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end    
  end
  
end