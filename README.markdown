Tog Social
==========

Tog Social is the plugin that adds basic social-network support to you site.

== Included functionality

# Profiles (including photos)
# Groups (including images)
# Moderated and open groups
# Public and private groups
# Invitations for joining a group
# Bi-directional friendships
# Followers and fan friendships

Resources
=========

Plugin requirements
-------------------

* https://github.com/tog/tog/wikis/3rd-party-plugins-acts_as_state_machine
* https://github.com/tog/tog/wikis/3rd-party-plugins-seo_urls
* https://github.com/tog/tog/wikis/3rd-party-plugins-file_column

Install
-------

If you used the command <code>togify</code> to install tog, then you already have tog_social installed.

If not, install it like any other plugin:

  
* Install plugin form source:

<pre>
ruby script/plugin install git@github.com:tog/tog_social.git
</pre>

* Generate installation migration:

<pre>
ruby script/generate migration install_tog_social
</pre>

	  with the following content:

<pre>
class InstallTogSocial < ActiveRecord::Migration
  def self.up
    migrate_plugin "tog_social", 1
  end

  def self.down
    migrate_plugin "tog_social", 0
  end
end
</pre>

* Add tog_social's routes to your application's config/routes.rb

<pre>
map.routes_from_plugin 'tog_social'
</pre> 

* And finally...

<pre> 
rake db:migrate
</pre> 

More
-------

"https://github.com/tog/tog_social":https://github.com/tog/tog_social

"https://github.com/tog/tog_social/wikis":https://github.com/tog/tog_social/wikis

"Creating relationships between users":https://github.com/tog/tog_social/wikis/creating-relationships-between-users

"Showing friends, followers or followings in a portlet":https://github.com/tog/tog_social/wikis/showing-friends-followers-or-followings-in-a-portlet



Copyright (c) 2008 Keras Software Development, released under the MIT license