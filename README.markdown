Tog Social
==========

Tog Social is the plugin that adds basic social-network support to you site. That is:

* Profiles (including photos)
* Groups (including images, moderated groups, public and private groups, invitation, etc.)
* Friendships (unidirectional or following/follower and bidirectional or friendships)


Resources
=========

Plugin requirements
-------------------



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