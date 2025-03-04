class CalendarsController < ApplicationController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user_or_line_user!, except: [:index, :show, :new, :create, :edit, :update, :destroy] 

  def index
    @calendars = Calendar.all
  end

  def new
    @calendar = Calendar.new
  end

  def create
    Rails.logger.debug "Create action called"
    @calendar = Calendar.new(calendar_params)
    @calendar.user ||= [current_user, current_guest, current_line_user].find(&:itself)

    if @calendar.user.nil?
      flash[:alert] = 'User must exist'
      render :new
      return
    end

    if @calendar.save
      Rails.logger.debug "Calendar saved successfully"
      if current_user
        @calendar.calendar_users.create(user: current_user)
      elsif current_guest
        @calendar.calendar_users.create(user: current_guest)
      elsif current_line_user
        @calendar.calendar_users.create(user: current_line_user)
      end

      if params[:schedule].present?
        Rails.logger.debug "Schedule params present, calling handle_successful_save"
        handle_successful_save
      else
        Rails.logger.debug "Redirecting to calendar path"
        redirect_to calendar_path(@calendar), notice: 'Calendar was successfully created.'
      end
    else
      error_messages = @calendar.errors.full_messages.join(', ')
      Rails.logger.error error_messages
      flash[:alert] = error_messages
      render :new
    end
  end

  def show
    @calendar = Calendar.find_by(id: params[:id])
    Rails.logger.debug "Debug - Calendar Found: #{@calendar.inspect}"

    if @calendar
      # カレンダーの表示権限を確認
      if authorized_to_view?(@calendar)
        session[:current_calendar_id] = @calendar.id
        @customize = Customize.find_by(calendar_id: @calendar.id)
        @events = @calendar.schedules.includes(:exercise)
  
        # @selected_dateを設定
        @selected_date = params[:date] ? Date.parse(params[:date]) : Date.today
        @schedules = @calendar.schedules.where(date: @selected_date) # 日付に基づくスケジュール表示
        @schedule = @calendar.schedules.new
        
      else
        Rails.logger.debug "Debug - Unauthorized to View Calendar"
        flash[:alert] = 'You are not authorized to view this calendar.'
        redirect_to calendars_path
      end
    else
      Rails.logger.debug "Debug - Calendar Not Found"
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
    expires_now
  end
  

  def edit
  end

  def update
    if @calendar.update(calendar_params)
      redirect_to calendars_path, notice: 'Calendar was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @calendar.destroy
    redirect_to calendars_path, notice: 'Calendar was successfully deleted.'
  end

  private

  def set_calendar
    @calendar = Calendar.find_by(id: params[:id])
    unless @calendar
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end

  def calendar_params
    params.require(:calendar).permit(:title, :image, :color, :image_url)
  end

  def schedule_params
    params.require(:schedule).permit(:start_time, :end_time, :exercise_id, :date, :repetitions, :duration)
  end

  def handle_successful_save
    @schedule = @calendar.schedules.build(schedule_params)
    if @schedule.save
      session[:current_calendar_id] = @calendar.id
      add_current_user_to_calendar if user_signed_in?
      redirect_to calendar_path(@calendar), notice: 'Calendar was successfully created.'
    else
      render :new
    end
  end

  def add_current_user_to_calendar
    @calendar.users << current_user unless @calendar.users.include?(current_user)
  end

  def add_current_line_user_to_calendar
    @calendar.line_users << current_line_user unless @calendar.line_users.include?(current_line_user)
  end

  def authorized_to_view?(calendar)
    Rails.logger.debug "Debug - Current User: #{current_user.inspect}"
    Rails.logger.debug "Debug - Current Line User: #{current_line_user.inspect}"
    Rails.logger.debug "Debug - Current Guest: #{current_guest.inspect}"
    Rails.logger.debug "Debug - Calendar User: #{calendar.user.inspect}"

    if current_user && calendar.users.exists?(id: current_user.id)
      Rails.logger.debug "Debug - Authorized as Current User"
      true
    elsif current_line_user && calendar.line_users.exists?(id: current_line_user.id)
      Rails.logger.debug "Debug - Authorized as Line User"
      true
    elsif current_guest && calendar.user == current_guest
      Rails.logger.debug "Debug - Authorized as Guest User"
      true  # GuestUserの場合はhas_oneのため単一カレンダーをチェック
    else
      Rails.logger.debug "Debug - Not Authorized"
      false
    end
  end
end