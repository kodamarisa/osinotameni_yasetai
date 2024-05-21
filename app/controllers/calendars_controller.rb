class CalendarsController < ApplicationController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :new, :create, :edit, :update, :destroy] 

  def index
    @calendars = Calendar.all
  end

  def show
    @calendar = Calendar.find_by(id: params[:id])
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
      session[:current_calendar_id] = @calendar.id
      redirect_to calendar_path(@calendar), notice: 'Calendar was successfully created.'
    else
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
    @calendar = Calendar.find(params[:id])
  end

  def calendar_params
    params.require(:calendar).permit(:title)
  end  
end
