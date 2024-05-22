class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]

  def new
    @schedule = Schedule.new
    @exercises = Exercise.all
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      redirect_to calendar_path(@schedule.calendar), notice: 'Schedule was successfully created.'
    else
      redirect_to calendar_path(params[:calendar_id]), alert: 'Error creating schedule.'
    end
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

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:date, :calendar_id, :exercise_id, :repetitions, :duration)
  end
end
