module SharingsHelper
  
  def share_with_groups_link(shareable, only_moderated_groups=false)
    return if !shareable
    groups = only_moderated_groups ? current_user.moderated_groups : current_user.groups
    render :partial => 'shared/share_with_groups', :locals => {:groups => groups, :shareable => shareable}
  end
    
    
  def share_link(link_text, share_with, shareable)
    if share_with.shared?(shareable)
      "#{link_text}<br/><small>#{I18n.t('tog_social.sharings.member.already_shared')}</small>"
    else
      link_to link_text,
          member_share_path(share_with, shareable.class.to_s, shareable.id),
          :method => :post,
          :html => {:title => I18n.t("tog_social.sharings.member.share_with", :name => share_with.name)}
    end
  end    
    
  def shareable_title(shareable)
    title_for_object(shareable)
  end  
  
  def title_for_object(obj)
    if (obj.respond_to?(:name))
      string = obj.name
    elsif (obj.respond_to?(:title))
      string = obj.title
    else
      string = "#{obj.class.name} / #{obj.id}"
    end
    string      
  end
  
end

