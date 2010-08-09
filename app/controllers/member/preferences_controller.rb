class Member::PreferencesController < Member::BaseController

  def edit
    @preferences = current_user.preferences
  end
  
  def update
    params[:preferences].each do |k,v|
      current_user.write_preference(k, v)
    end
    current_user.save!
    flash[:ok] = I18n.t('tog_social.preferences.member.saved')
    redirect_to :back
  end

end