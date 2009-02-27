class StreamsController < ApplicationController
  before_filter :find_user, :only => [:show, :network]

  def index
    @activities = Activity.created_since 1.week.ago

    respond_to do |wants|
      wants.html # index.html.erb
      wants.rss  { render :layout => false }
      wants.xml  { render :xml => @activities }
    end
  end

  def show
    @activities = Activity.by_user(@user)
    respond_to do |wants|
      wants.html # show.html.erb
      wants.rss  { render :layout => false }
      wants.xml  { render :xml => @activities }
    end
  end
  
  def network
    @activities = Activity.by_user(@user.network)
    respond_to do |wants|
      wants.html # show.html.erb
      wants.rss  { render :layout => false}
      wants.xml  { render :xml => @activities }
    end
    
  end

  private
  def find_user
    @user = User.find(params[:id])
  end

end
