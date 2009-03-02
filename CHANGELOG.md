Edge
----

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