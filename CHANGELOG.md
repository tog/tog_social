Edge
----

* Fixed some locale keys
* Helper method for showing an object's title/name while sharing
* Fixed sharing link in sharings_helper, now updates HTML for showing operation's result (kudos to Andrei Erdoss)

0.5.1
----

* Issue tracker moved to github: http://github.com/tog/tog_social/issues 
* Remove profile activity record
* Fixed #1. URL for removing friends in profiles_helper_

0.5.0
----
* Oauth model typo fixed
* Memberships of a user should be deleted when the user itself is
* Correctly requiring the host app's environment
* Another fix by @eparreno, the new doc bug hunter.
* Renamed routes.rb to desert_routes.rb
* Changed Test::Unit to ActiveSupport
* Fix deprecated call to should_redirect_to
* I18n 99.99%
* I18n group members portlet
* Getting up to date with spanish translations
* Addind optional parameter 'profile' to its_me? method
* String rendered as interpolation, not concatenation
* tog_core required
* Memberships of a user should be deleted when the user itself is - kudos to @balinterdi
* Moved share_ink to sharings_helper
* Invite to groups
* Removing sharings
* public/private and active namescopes for groups
* Can edit groups from admin view
* Checking that the user who created the group still exists, just in case he destroyed his account
* Overloaded share method
* Removed duplicated method 'share'
* refer to host app environment
* Removed version

0.4.4
----

0.4.3
----
* Activity Streams first approach.
* Models and controllers updated to use the new acts_as_scribe 0.1 

0.4.2
----
* Ticket #118. i18n in navigation tabs
* Fixed #117. Full name and user's login used on moderated group joined notification.
* has_many :activities added to user thanks to record\_activities macro provided by acts\_as\_scribe. kudos to John Paul for catch this one.
* Adding a friend should be moderated [#123 state:resolved]
* Added links in friendship messages
* Added some flashes

0.4.0
----
* beta oauth support
* Migrated from FileColumn to Paperclip
* link for editing user's profile
* Only pending users should be displayed on the profiles section


0.3.0
----
* Fix memberships relation and redirection after delete
* New styles applied and tabs removed
* Tag search view
* Replace "name" with "profile.full_name"
* Name method removed
