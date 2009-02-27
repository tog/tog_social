class Member::FriendshipsController < Member::BaseController

  before_filter :find_friend_profile

  def add_friend
    if @friend.add_follower(current_user.profile)
      flash[:ok]=I18n.t("tog_social.friendships.member.friend.added", :friend_name => @friend.full_name)
      Message.new(
        :from => current_user,
        :to   => @friend.user,
        :subject => I18n.t("tog_social.friendships.member.mail.add_friend.subject", :user_name => current_user.profile.full_name),
        :content => I18n.t("tog_social.friendships.member.mail.add_friend.content", 
                           :user_name   => current_user.profile.full_name, 
                           :friend_name => @friend.full_name, 
                           :user_profile_url => profile_url(current_user.profile) , 
                           :confirm_url      => member_confirm_friend_url(current_user.profile))
      ).dispatch!
    end
    redirect_back_or_default(profile_path(current_user.profile))
  end

  def confirm_friend
    if @friend.follows?(current_user.profile) && @friend.add_follower(current_user.profile)
      flash[:ok]=I18n.t("tog_social.friendships.member.friend.confirmed", :friend_name => @friend.full_name)
      Message.new(
        :from => current_user,
        :to   => @friend.user,
        :subject => I18n.t("tog_social.friendships.member.mail.confirm_friend.subject", :user_name => current_user.profile.full_name),
        :content => I18n.t("tog_social.friendships.member.mail.confirm_friend.content", 
                           :user_name   => current_user.profile.full_name, 
                           :friend_name => @friend.full_name, 
                           :user_profile_url => profile_url(current_user.profile)) 
      ).dispatch! 
    end

    redirect_back_or_default(profile_path(current_user.profile))
  end

  def follow
    if @friend.add_follower(current_user.profile)
      flash[:ok]=I18n.t("tog_social.friendships.member.followed", :user_name => @friend.full_name)
      Message.new(
        :from => current_user,
        :to   => @friend.user,
        :subject => I18n.t("tog_social.friendships.member.mail.follow.subject", :user_name => current_user.profile.full_name),
        :content => I18n.t("tog_social.friendships.member.mail.follow.content", 
                           :user_name   => current_user.profile.full_name, 
                           :friend_name => @friend.full_name, 
                           :user_profile_url => profile_url(current_user.profile))
      ).dispatch!
    end
    redirect_back_or_default(profile_path(current_user.profile))    
  end

  def unfollow
    if @friend.remove_follower(current_user.profile)
      flash[:ok]=I18n.t("tog_social.friendships.member.unfollowed", :user_name => @friend.full_name)
      Message.new(
        :from => current_user,
        :to   => @friend.user,
        :subject => I18n.t("tog_social.friendships.member.mail.unfollow.subject", :user_name => current_user.profile.full_name),
        :content => I18n.t("tog_social.friendships.member.mail.unfollow.content", 
                           :user_name   => current_user.profile.full_name, 
                           :friend_name => @friend.full_name, 
                           :user_profile_url => profile_url(current_user.profile))
      ).dispatch!
    end
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