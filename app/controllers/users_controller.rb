class UsersController < ApplicationController
  before_action :authenticate_user_or_line_user!

  def profile
    if current_user
      @user = current_user
    elsif current_line_user
      @line_user = current_line_user
    else
      redirect_to new_user_session_path
    end
  end

  private

  def authenticate_user_or_line_user!
    if user_signed_in?
      authenticate_user!
    elsif line_user_signed_in?
      authenticate_line_user!
    else
      redirect_to new_registration_path
    end
  end
end