class CalendarsController < ApplicationController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :new, :create, :edit, :update, :destroy] 

  def index
    @calendars = Calendar.all
  end

  def show
    @customize = Customize.find_by(calendar_id: @calendar.id)
    if @calendar
      @events = @calendar.schedules
    else
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
    expires_now
  end

  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = Calendar.new(calendar_params)
    if @calendar.save
      handle_successful_save
    else
      render :new
    end
  end

  def edit
    @calendar = Calendar.find(params[:id])
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

  def handle_successful_save
    if @calendar
      session[:current_calendar_id] = @calendar.id
      add_current_user_to_calendar if user_signed_in?
      redirect_to calendar_path(@calendar), notice: 'Calendar was successfully created.'
    else
      redirect_to calendars_path, alert: 'Error creating calendar.'
    end
  end
  
  
  def add_current_user_to_calendar
    @calendar.users << current_user
  end
end