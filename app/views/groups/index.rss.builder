xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("#{config['plugins.tog_core.site.name']} #{I18n.t('tog_social.groups.site.last_groups')}")
    xml.link groups_url
    xml.description("#{@groups.size} #{I18n.t('tog_social.groups.site.last_groups')}")
    xml.language(I18n.locale.to_s)
      for g in @groups    
          xml.item do
            xml.title(g.name)
            xml.description(g.description)      
            xml.pubDate(g.creation_date(:long))
            xml.author(g.author.profile.full_name)  
            xml.link(group_url(g))               
            xml.guid(g.id)
          end
      end
  }
}
