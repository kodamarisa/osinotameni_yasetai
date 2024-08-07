class CalendarsController < ApplicationController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user_or_line_user!, except: [:index, :show, :new, :create, :edit, :update, :destroy] 

  def index
    @calendars = Calendar.all
  end

  def show
    if @calendar
      @customize = Customize.find_by(calendar_id: @calendar.id)
      @events = @calendar.schedules.includes(:exercise)
    else
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
      return
    end
    expires_now
  end

  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = Calendar.new(calendar_params)
    @calendar.user = [current_user, current_guest, current_line_user].find(&:itself)

    if @calendar.user.nil?
      flash[:alert] = 'User must exist'
      render :new
      return
    end

    if @calendar.save
        @calendar.calendar_users.create(user: current_guest) if current_guest && @calendar.save

      if params[:schedule].present?
        handle_successful_save
      else
        redirect_to calendar_path(@calendar), notice: 'Calendar was successfully created.'
      end
    else
      error_messages = @calendar.errors.full_messages.join(', ')
      Rails.logger.error error_messages
      flash[:alert] = error_messages
      render :new
    end
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
      @calendar = Calendar.create(title: "Default Calendar")
      session[:current_calendar_id] = @calendar.id
    end
  end

  def calendar_params
    params.require(:calendar).permit(:title, :image)
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
    @calendar.users << current_user
  end

  def add_current_line_user_to_calendar
    @calendar.line_users << current_line_user
  end
end
