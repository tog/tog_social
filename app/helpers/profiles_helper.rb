module ProfilesHelper

  def icon_for_profile(profile, size, options={})
    if profile.icon 
      photo_url = url_for_image_column(profile, "icon", :name => size)
      options.merge!(:alt => "Foto del usuario: #{profile.full_name}")
      return image_tag(photo_url, options) if photo_url    
    else
      return image_tag(config["system.profile.image.default"], options)
  	end 
  end
  
end
