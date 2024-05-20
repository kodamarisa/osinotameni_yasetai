class RegistrationsController < ApplicationController
  def new
    render 'new'
  end

  def line_registration
    render 'line_users/new'
  end

  def email_registration
    redirect_to new_user_registration_path
  end
end
