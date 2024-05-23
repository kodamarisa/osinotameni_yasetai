class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = LineUser.find_or_create_by(line_user_id: auth['uid']) do |u|
      u.name = auth['info']['name']
      u.profile_image_url = auth['info']['image']
      u.access_token = auth['credentials']['token']
      u.refresh_token = auth['credentials']['refresh_token']
    end

    if user.save
      session[:line_user_id] = user.id
      redirect_to user_profile_path, notice: 'Successfully logged in with LINE!'
    else
      redirect_to root_path, alert: 'Failed to login with LINE.'
    end
  end

  def destroy
    session[:line_user_id] = nil
    redirect_to root_path, notice: 'Logged out successfully.'
  end
end
