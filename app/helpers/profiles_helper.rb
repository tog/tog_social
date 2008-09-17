module ProfilesHelper

  def icon_for_profile(profile, size, options={})
    if profile.icon 
      photo_url = url_for_image_column(profile, "icon", :name => size)
      options.merge!(:alt => "Photo for user: #{profile.full_name}")
      return image_tag(photo_url, options) if photo_url    
    else
      return image_tag(config["plugins.tog_social.profile.image.default"], options)
  	end 
  end
  
  def its_me?
    logged_in? && @profile && current_user.profile == @profile
  end

  def following_options(profile=@profile) 
    if logged_in? && current_user.profile.follows?(profile) 
      link_to "Stop following #{profile.full_name}", member_unfollow_user_path(profile)
    else
      link_to "Follow #{profile.full_name}", member_follow_user_path(profile)
    end                   
  end
    
  def friendship_options(profile=@profile) 
    if logged_in? && current_user.profile.is_friend_of?(profile) 
      link_to "Remove #{profile.full_name} as a friend", member_remove_friend_path(profile)
    else
      link_to "Add #{profile.full_name} as a friend", member_add_friend_path(profile)
    end                   
  end
  
end
