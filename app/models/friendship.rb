# Friendship objects represents the relation between two different members of the social network. The cardinality of the relationship is based on "inviter" and "invited" fields
# that store who started the relationship and who is the _passive_ subject of the relationship.
# 
#  If you have two profiles, tom and jerry, the following combinations can take place:
#
#  inviter  invited  status
#  -------  -------  -------
#  tom      jerry    pending   tom is a follower of jerry OR jerry is followed by tom OR jerry is a 'following' of tom  
#  jerry    tom      pending   jerry is a follower of tom OR tom is followed by jerry OR tom is a 'following' of jerry
# 
#  jerry    tom      accept  |                               | jerry "begun" the friendship
#  or                        |  jerry and tom are friends    |    
#  jerry    tom      accept  |                               | tom "begun" the friendship

class Friendship  < ActiveRecord::Base
   belongs_to :inviter, :class_name => 'Profile'
   belongs_to :invited, :class_name => 'Profile'
   
   PENDING  = 0
   ACCEPTED = 1
   
   def validate
     errors.add('inviter', 'inviter and invited can not be the same user') if invited == inviter
   end
   class << self
      
      # Create a new follower of the +inviter+ user. Returns boolean value indicating if the relationship
      # correctly created.
      #
      # ==== Options
      #
      # +inviter+  +Profile+ if the person that wants to be a follower if +invited+
      # 
      # +invited+  +Profile+ of the user followed by +inviter+
      #
      def add_follower(inviter, invited)
        # todo enable send_friendships_notifications? setting per profile
        # FriendshipMailer.deliver_new_follower(me, follower)  if me.send_friendships_notifications?
        #FriendshipMailer.deliver_new_follower(me, follower)
        a = Friendship.create(:inviter => inviter, :invited => invited, :status => PENDING)
        !a.new_record?
      end
          
      # Create a friendship between the user and the target. Returns boolean value indicating if
      # the relationship was correctly created.
      #
      # ==== Options
      #
      # +user+    +Profile+ or +User+ that purpose the friendship 
      #
      # +target+  +Profile+ or +User+ that receives the purposement relationship 
      #
      def make_friends(user, target)
        transaction do
          user = profile_of(user)
          target = profile_of(target)
          begin
            find_friendship(user, target, PENDING).update_attribute(:status, ACCEPTED)
            Friendship.create!(:inviter_id => target.id, :invited_id => user.id, :status => ACCEPTED)
          rescue Exception
            return make_friends(target, user) if user.followed_by? target
            return add_follower(user, target)
          end
        end
        true
      end

      def stop_being_friends(user, target)
      transaction do
        begin
          find_friendship(target, user, ACCEPTED).update_attribute(:status, PENDING)
          find_friendship(user, target, ACCEPTED).destroy
          rescue Exception
            return false
          end
        end
        true
      end

      def reset(user, target)
        begin
          find_friendship(user, target).destroy
          find_friendship(target, user, ACCEPTED).update_attribute(:status, PENDING)
        rescue Exception
          return true
        end
        true
      end
      
      private
      
      def find_friendship(inviter, invited, status)
         conditions = {:inviter_id => inviter.id, :invited_id => invited.id}
         conditions.merge!(:status => status) if status
         Friendship.find(:first, :conditions => conditions)
      end
      
   end     

   def accept!
    self.update_attribute(:status, ACCEPTED)
   end

   private
   def profile_of(user)
     profile = case user
     when User
       user.profile
     when Profile
       user
     else
       nil
     end
   end
   
end