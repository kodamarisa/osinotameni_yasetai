# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # app/controllers/users/sessions_controller.rb
  def create
    super do |resource|
      if resource.persisted? && resource.valid_password?(params[:user][:password])
        if session[:guest_user_id]
          guest_user = GuestUser.find(session[:guest_user_id])
          guest_calendar = Calendar.find_by(user_id: guest_user.id, user_type: 'GuestUser')
          
          user_calendar = Calendar.find_by(user_id: resource.id, user_type: 'User')
          
          # 既にユーザーにカレンダーがある場合はゲストカレンダーを削除
          if user_calendar.nil? && guest_calendar
            guest_calendar.update(user: resource, user_type: 'User')
          else
            guest_calendar&.destroy
          end
  
          # ゲストユーザーを削除
          guest_user.destroy
          session.delete(:guest_user_id)
        end
  
        # ユーザーに関連するカレンダーをセッションに設定
        calendar = Calendar.find_by(user_id: resource.id, user_type: 'User')
        if calendar
          session[:current_calendar_id] = calendar.id
          redirect_to calendar_path(calendar) and return
        else
          redirect_to root_path, alert: '関連付けられたカレンダーが見つかりません。' and return
        end
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
