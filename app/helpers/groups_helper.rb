module GroupsHelper
  
  def tag_cloud_groups(classes)
    tags = Group.tag_counts(:conditions => "state= 'active' and private = 0")
    return if tags.empty?
    max_count = tags.sort_by(&:count).last.count.to_f
    tags.each do |tag|
      index = ((tag.count / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end

  def image_for_group(group, size, options={})
    if group.image 
      photo_url = url_for_image_column(group, "image", :name => size)
      options.merge!(:alt => "Photo for group: #{group.name}")
      return image_tag(photo_url, options) if photo_url    
    else
      return image_tag(config["plugins.tog_social.group.image.default"], options)
  	end    
  end


  def last_groups(limit=3)
    Group.find(:all,:conditions => ["state= ? and private = ?", 'active', false],:order => "created_at desc", :limit => limit)
  end  
  
  
  def i_am_member_of(group)
    return group.members.include?(current_user)
  end
  def i_am_moderator_of(group)
    return group.moderators.include?(current_user)
  end  
  
end
