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
      @calendar.calendar_users.create(user: current_guest) if current_guest

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
    if @calendar
      # カレンダーの表示権限を確認
      if authorized_to_view?(@calendar)
        session[:current_calendar_id] = @calendar.id
        @customize = Customize.find_by(calendar_id: @calendar.id)
        @events = @calendar.schedules.includes(:exercise)
  
        # @selected_dateを設定
        @selected_date = params[:date] ? Date.parse(params[:date]) : Date.today
        @schedules = @calendar.schedules.where(date: @selected_date) # 日付に基づくスケジュール表示
      else
        flash[:alert] = 'You are not authorized to view this calendar.'
        redirect_to calendars_path
      end
    else
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
    if current_user
      calendar.users.include?(current_user)
    elsif current_line_user
      calendar.line_users.include?(current_line_user)
    elsif current_guest
      calendar.user == current_guest  # GuestUserの場合はhas_oneのため単一カレンダーをチェック
    else
      false
    end
  end
end
