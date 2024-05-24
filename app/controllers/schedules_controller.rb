class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]

  def new
    @schedule = Schedule.new
    @exercises = Exercise.all

    session[:current_calendar_id] = params[:calendar_id]
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if params[:calendar_id].present?
      @schedule.calendar_id = params[:calendar_id]
    else
      @schedule.calendar_id = default_calendar_id
    end
  
    if @schedule.save
      redirect_to calendar_path(@schedule.calendar), notice: 'Schedule was successfully created.'
    else
      redirect_to new_schedule_path(date: params[:date], calendar_id: params[:calendar_id]), alert: 'Error creating schedule.'
    end
  end
  

  def show
    @schedule = Schedule.find(params[:id])
  end

  def edit
    @exercises = Exercise.all
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to calendar_path(@schedule.calendar), notice: 'Schedule was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    calendar = @schedule.calendar
    @schedule.destroy
    redirect_to calendar_path(calendar), notice: 'Schedule was successfully deleted.'
  end

  private

  def default_calendar_id
    calendar_id = session[:current_calendar_id]
  end

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:date, :calendar_id, :exercise_id, :repetitions, :duration)
  end
end
