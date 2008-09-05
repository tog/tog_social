# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

resources :profiles

with_options(:controller => 'groups') do |group|
  group.tag_groups  '/groups/tag/:tag',  :action => 'tag'
end

resources :groups, :collection => { :search => :get }, :member => { :join => :get, :leave => :get }

namespace(:member) do |member|
  member.resources :groups
  member.with_options(:controller => 'groups') do |group|
    group.group_pending_members  '/:id/members/pending',  :action => 'pending_members'
    group.group_accept_member  '/:id/members/:user_id/accept',  :action => 'accept_member'
    group.group_reject_member  '/:id/members/:user_id/reject',  :action => 'reject_member'
  end
end

namespace(:admin) do |admin|
  admin.resources :groups, :member => { :activate => :post}
end