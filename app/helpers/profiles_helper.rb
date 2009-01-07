module ProfilesHelper

  def icon_for_profile(profile, size, options={})
    if profile.icon?
      photo_url = profile.icon.url(size)
      options.merge!(:alt => "Photo for user: #{profile.full_name}")
      return image_tag(photo_url, options) if photo_url
    else
      return image_tag("/tog_social/images/#{config["plugins.tog_social.profile.image.default"]}" , options)
    end
  end

  def its_me?
    logged_in? && @profile && current_user.profile == @profile
  end

  def following_options(profile=@profile)
    if logged_in? && current_user.profile.follows?(profile)
      link_to I18n.t("tog_social.profiles.helper.unfollow_user", :name => profile.full_name), member_unfollow_user_path(profile)
    else
      link_to I18n.t("tog_social.profiles.helper.follow_user", :name => profile.full_name), member_follow_user_path(profile)
    end
  end

  def friendship_options(profile=@profile)
    if logged_in? && current_user.profile.is_friend_of?(profile)
      link_to I18n.t("tog_social.profiles.helper.remove_friend", :name => profile.full_name), member_remove_friend_path(profile)
    else
      link_to I18n.t("tog_social.profiles.helper.add_friend", :name => profile.full_name), member_add_friend_path(profile)
    end
  end

end
