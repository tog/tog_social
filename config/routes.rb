# Add your custom routes here.  If in config/routes.rb you would
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

resources :profiles

resources :streams, :only => [:index, :show]

with_options(:controller => 'groups') do |group|
  group.tag_groups       '/groups/tag/:tag',                         :action => 'tag'
end

resources :groups, :collection => { :search => :get }, :member => { :join => :get, :leave => :get }

namespace(:member) do |member|
  member.resources :profiles
  member.resources :groups
  member.with_options(:controller => 'groups') do |group|
    group.group_pending_members '/:id/members/pending',         :action => 'pending_members'
    group.group_accept_member   '/:id/members/:user_id/accept', :action => 'accept_member'
    group.group_reject_member   '/:id/members/:user_id/reject', :action => 'reject_member'
  end
  member.with_options(:controller => 'friendships') do |friendship|
    friendship.add_friend     '/friend/:friend_id/add',     :action => 'add_friend'
    friendship.confirm_friend '/friend/:friend_id/confirm', :action => 'confirm_friend'
    friendship.follow_user    '/follow/:friend_id',         :action => 'follow'
    friendship.unfollow_user  '/unfollow/:friend_id',       :action => 'unfollow'
  end
  member.with_options(:controller => 'sharings') do |sharing|
    sharing.share '/share/:shareable_type/:shareable_id', :action => 'index'
    sharing.share_with_group '/group/:id/share/:shareable_type/:shareable_id', :action => 'share'
  end
end

namespace(:admin) do |admin|
  admin.resources :groups, :member => { :activate => :post}
end

# => oauth support
resources :oauth_clients
authorize     '/oauth/authorize',     :controller=>'oauth', :action=>'authorize'
request_token '/oauth/request_token', :controller=>'oauth', :action=>'request_token'
access_token  '/oauth/access_token',  :controller=>'oauth', :action=>'access_token'
test_request  '/oauth/test_request',  :controller=>'oauth', :action=>'test_request'

x1 '/oauth_test',     :controller=>'oauth_test', :action=>'test'
x2 '/oauth_callback', :controller=>'oauth_test', :action=>'callback'
# => oauth support