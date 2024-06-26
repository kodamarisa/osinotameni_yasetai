# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super do |resource|
      if session[:current_calendar_id].present?
        calendar = Calendar.find(session[:current_calendar_id])
        redirect_to calendar_path(calendar)
        return
      end
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super do
      redirect_to root_path and return
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
