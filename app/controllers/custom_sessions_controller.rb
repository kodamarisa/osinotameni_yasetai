class CustomSessionsController < ApplicationController
  def new
  end

  def create
    session[:anonymous_user_id] = user.id
    redirect_to calendars_path, notice: 'Successfully logged in!'
  end

  def destroy
  end
end
