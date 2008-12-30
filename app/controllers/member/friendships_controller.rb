class Member::FriendshipsController < Member::BaseController
 
  before_filter :find_friend_profile
  
  def add_friend
    current_user.profile.add_friend(@friend) 
    redirect_back_or_default(profile_path(current_user.profile))
  end
  
  def remove_friend
    current_user.profile.remove_friend(@friend)
    redirect_back_or_default(profile_path(current_user.profile)) 
  end
  
  def follow
    @friend.add_follower(current_user.profile)
    redirect_back_or_default(profile_path(current_user.profile))
  end
  
  def unfollow
    @friend.remove_follower(current_user.profile)   
    redirect_back_or_default(profile_path(current_user.profile)) 
  end
  
  private 
  
    def find_friend_profile
      @friend = Profile.find(params[:friend_id]) 
      unless @friend 
        flash[:error] = I18n.t("tog_social.friendships.member.not_found", :id => params[:friend_id].to_s)
        redirect_to profiles_path 
      end  
    end
end