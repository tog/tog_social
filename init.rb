require_plugin 'tog_core'
require_plugin 'acts_as_state_machine'

Tog::Plugins.settings :tog_social, "group.image.storage"         => "file_system",
                                   "group.image.versions.big"    => "128x128",
                                   "group.image.versions.medium" => "72x72",
                                   "group.image.versions.small"  => "25x25",
                                   "group.image.versions.tiny"   => "12x12"
                                   
Tog::Plugins.settings :tog_social, "profile.image.default"         => "default_profile.png",
                                   "profile.image.versions.big"    => "150x150",
                                   "profile.image.versions.medium" => "100x100",
                                   "profile.image.versions.small"  => "50x50",
                                   "profile.image.versions.tiny"   => "25x25"

