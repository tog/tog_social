require_plugin 'tog_core'
require_plugin 'tog_mail'
require_plugin 'acts_as_state_machine'
require_plugin 'seo_urls'
require_plugin 'paperclip'

require "i18n" unless defined?(I18n)
Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_path << file
end

Tog::Plugins.settings :tog_social, "group.image.storage"         => "file_system",
                                   "group.image.versions.big"    => "128x128#",
                                   "group.image.versions.medium" => "72x72#",
                                   "group.image.versions.small"  => "25x25#",
                                   "group.image.versions.tiny"   => "12x12#",
                                   "group.image.default"         => "default_group.png"

Tog::Plugins.settings :tog_social, "group.moderation.creation"   => false

Tog::Plugins.settings :tog_social, "profile.image.default"         => "default_profile.png",
                                   "profile.image.versions.big"    => "150x150#",
                                   "profile.image.versions.medium" => "100x100#",
                                   "profile.image.versions.small"  => "50x50#",
                                   "profile.image.versions.tiny"   => "25x25#",
                                   "profile.list.page.size"        => "10"

# oauth beta support
gem 'oauth', '>=0.2.1'
require 'oauth/signature/hmac/sha1'
require 'oauth/request_proxy/action_controller_request'
require 'oauth/server'
require 'tog_oauth_controller_methods'

Tog::Plugins.helpers ProfilesHelper, GroupsHelper, SharingsHelper

Tog::Interface.sections(:site).add "Profiles", "/profiles"     
Tog::Interface.sections(:site).add "Groups", "/groups"     
Tog::Interface.sections(:member).add "My groups", "/member/groups"     
Tog::Interface.sections(:admin).add "Groups", "/admin/groups"

Tog::Search.sources << "Group"
Tog::Search.sources << "Profile"     
