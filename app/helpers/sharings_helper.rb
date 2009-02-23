module SharingsHelper
  
  def share_link(text, shared, shareable)
    link_to_remote text, :url => member_share_with_group_path(shared, shareable.type, shareable.id), 
        :html => {:title => I18n.t("tog_social.sharing.share_with", :name => shared.name)} 
  end
  
end

