# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  def choose
    if user_signed_in?
      redirect_to user_profile_path
    end
  end

  # POST /resource
  def create
    super do |user|
      if session[:guest_user_id]
        guest_user = GuestUser.find(session[:guest_user_id])
        Rails.logger.info "Guest user found: #{guest_user.id}"
  
        guest_calendar = if session[:current_calendar_id]
                            Calendar.find_by(id: session[:current_calendar_id], user_id: guest_user.id, user_type: 'GuestUser')
                         else
                            Calendar.find_by(user_id: guest_user.id, user_type: 'GuestUser')
                         end
        
  
        if guest_calendar
          Rails.logger.info "Found guest calendar: #{guest_calendar.inspect}"
          Rails.logger.debug "Guest calendar successfully linked to user: #{guest_calendar.id}"
          guest_calendar.update(user: user, user_type: 'User')
          CalendarUser.create(calendar: guest_calendar, user: user) # CalendarUser レコードを作成
          session[:current_calendar_id] = guest_calendar.id
          Rails.logger.info "Guest calendar successfully linked to user. New calendar ID: #{guest_calendar.id}"
        else
          new_calendar = Calendar.create(user: user, user_type: 'User')
          session[:current_calendar_id] = new_calendar.id
          Rails.logger.info "New calendar created for user. Calendar ID: #{new_calendar.id}"
        end
  
        # ゲストユーザーとそのセッション情報の削除
        guest_user.destroy
        session.delete(:guest_user_id)
        Rails.logger.info "Guest user destroyed and session cleared."
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    user_profile_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end