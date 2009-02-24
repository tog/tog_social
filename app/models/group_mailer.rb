class GroupMailer < ActionMailer::Base

  def join_request(group, user)
      setup_email(user.email, group.author.email)
      @subject    += " Request for joining #{group.name}"
      @body[:url]  = member_group_pending_members_url(group)
      @body[:group] = group
      @body[:user] = user           
  end
    
  def accept_join_request(group, moderator, user)
      setup_email(moderator.email, user.email)
      @subject    += " Your request for joining #{group.name} has been accepted"
      @body[:url]  = group_url(group)
      @body[:group] = group
      @body[:user] = user           
  end

  def reject_join_request(group, moderator, user)
      setup_email(moderator.email, user.email)
      @subject    += " Your request for joining #{group.name} has been rejected"
      @body[:url]  = group_url(group)
      @body[:group] = group
      @body[:user] = user
      @body[:moderator] = moderator
      @body[:moderator_url] = profile_url(moderator)   
  end
  
  def invitation(group, moderator, user)
      setup_email(moderator.email, user.email)
      @subject    += " Invitation for joining group #{group.name}"
      @content_type = "text/html"
      @body[:group_url]  = group_url(group)
      mem = group.membership_of(user)
      @body[:accept_url]  = groups_invitation_accept_url(mem)
      @body[:reject_url]  = groups_invitation_reject_url(mem)
      @body[:group] = group         
  end    
      
  protected
    def setup_email(from, to)
      @recipients  = "#{to}"
      @from        = "#{from}"
      @content_type = "text/html"
      @subject     = Tog::Config["plugins.tog_core.mail.default_subject"]
      @sent_on     = Time.now
    end
end
