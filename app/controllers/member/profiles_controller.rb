class Member::ProfilesController < Member::BaseController

  def edit
    @profile = current_user.profile
  end

  def update
    profile = current_user.profile
    profile.update_attributes!(params[:profile])
    profile.save
    flash[:ok] = I18n.t("tog_social.profiles.member.updated") 
    redirect_to profile_path(profile)
  end

end