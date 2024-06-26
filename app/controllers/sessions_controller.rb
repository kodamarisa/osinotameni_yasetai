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
      if session[:guest_user_id].present?
        guest = GuestUser.find_by(id: session[:guest_user_id])
        if guest.present? && guest.calendar.present?
          guest.calendar.update(user: user)
          guest.destroy
          session[:guest_user_id] = nil
        end
      end
  
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

  def current_line_user
    @current_line_user ||= LineUser.find_by(id: session[:line_user_id])
  end

  helper_method :current_line_user
end
