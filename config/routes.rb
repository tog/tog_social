# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

resources :profiles

with_options(:controller => 'groups') do |group|
  group.tag_groups  '/groups/tag/:tag',  :action => 'tag'
end

resources :groups, :collection => { :search => :get }, :member => { :join => :get, :leave => :get }

namespace(:member) do |member|
  member.resources :groups, :collection => { :my_groups => :get }
  member.with_options(:controller => 'groups') do |group|
    group.pending_members  '/:id/members/pending',  :action => 'pending_members'
  end
end