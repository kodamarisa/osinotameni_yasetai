class CalendarsController < ApplicationController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]

  def index
    @calendars = current_user.calendars
    @calendar = Calendar.new
  end

  def show
    @events = @calendar.schedules
  end

  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = current_user.calendars.build(calendar_params)
    if @calendar.save
      redirect_to calendars_path, notice: 'Calendar was successfully created.'
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

  def destroy
    @calendar.destroy
    redirect_to calendars_url, notice: 'Calendar was successfully destroyed.'
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:id])
  end

  def calendar_params
    params.require(:calendar).permit(:title, :color, :image_url)
  end
end
