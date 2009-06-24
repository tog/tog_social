module SharingsHelper
  
  def share_with_groups_link(shareable, only_moderated_groups=false)
    return if !shareable
    groups = only_moderated_groups ? current_user.moderated_groups : current_user.groups
    render :partial => 'shared/share_with_groups', :locals => {:groups => groups, :shareable => shareable}
  end
    
  def share_link(text, share_with, shareable)
    link_to_remote text, 
        :update => "share_with_groups_message",
        :url => member_share_with_group_path(share_with, shareable.type, shareable.id),
        :html => {:title => I18n.t("tog_social.sharings.share_with", :name => share_with.name)}
  end
  
  def shareable_title(shareable)
    if (shareable.respond_to?(:name))
      string = shareable.name
    else
      string = shareable.title
    end
    string
  end  
end

