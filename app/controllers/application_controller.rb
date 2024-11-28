class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_line_user
  before_action :set_current_calendar

  helper_method :current_line_user, :line_user_signed_in?
  helper_method :current_guest
  helper_method :current_user_or_line_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def set_current_line_user
    if session[:line_user_id].present?
      @current_line_user = LineUser.find_by(id: session[:line_user_id])
    else
      @current_line_user = nil
    end
  end

  def current_line_user
    @current_line_user
  end

  def line_user_signed_in?
    @current_line_user.present?
  end

  def authenticate_user_or_line_user!
    Rails.logger.debug "Debug - Current User: #{current_user.inspect}"
    Rails.logger.debug "Debug - Current Line User: #{current_line_user.inspect}"
    Rails.logger.debug "Debug - Current User or Line User: #{current_user_or_line_user.inspect}"

    unless current_user_or_line_user
      redirect_to root_path, alert: 'You must be logged in to access this section.'
    end
  end

  def current_user_or_line_user
    if user_signed_in?
      current_user
    elsif line_user_signed_in?
      current_line_user
    else
      nil
    end
  end

  def set_current_calendar
    user = current_user_or_line_user || current_guest
    Rails.logger.debug "Debug - Current Calendar ID in Session: #{session[:current_calendar_id]}"
    Rails.logger.debug "Debug - User: #{user.inspect}"

    if session[:current_calendar_id].present?
      @current_calendar = Calendar.find_by(id: session[:current_calendar_id], user_id: user.id)
    else
      existing_calendar = Calendar.find_by(user_id: user.id, user_type: user.class.name)
      @current_calendar = existing_calendar || Calendar.create(title: "Default Calendar", user: user)
      session[:current_calendar_id] = @current_calendar.id
      Rails.logger.debug "Debug - New Calendar ID set in session: #{session[:current_calendar_id]}"
    end

    Rails.logger.debug "Debug - Current Calendar: #{@current_calendar.inspect}"
  end

  def current_calendar
    @current_calendar
  end

  def current_guest
    if session[:guest_user_id]
      guest_user = GuestUser.find_by(id: session[:guest_user_id])
      return guest_user if guest_user
    end

    guest_user = GuestUser.create!
    session[:guest_user_id] = guest_user.id
    guest_user
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Guest user not found: #{e.message}"
    session.delete(:guest_user_id)
    guest_user = GuestUser.create!
    session[:guest_user_id] = guest_user.id
    guest_user
  end
end