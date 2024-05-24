class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_line_user
  before_action :set_current_calendar

  helper_method :current_line_user, :line_user_signed_in?
  
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
    unless current_user || current_line_user
      redirect_to root_path, alert: 'You must be logged in to access this section.'
    end
  end

  def set_current_calendar
    if params[:calendar_id].present?
      @current_calendar = Calendar.find_by(id: params[:calendar_id])
    elsif session[:current_calendar_id].present?
      @current_calendar = Calendar.find_by(id: session[:current_calendar_id])
    else
      @current_calendar = Calendar.create(title: "Default Calendar")
      session[:current_calendar_id] = @current_calendar.id
    end
  end

  def current_calendar
    @current_calendar
  end
end
