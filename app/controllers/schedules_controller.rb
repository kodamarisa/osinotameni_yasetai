class SchedulesController < ApplicationController
  before_action :set_calendar
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  def new
    @schedule = @calendar.schedules.build
    @exercises = Exercise.all
  end

  def create
    @schedule = @calendar.schedules.build(schedule_params)

    if @schedule.save
      redirect_to calendar_path(@calendar), notice: 'Schedule was successfully created.'
    else
      @exercises = Exercise.all
      render :new
    end
  end

  def show
  end

  def edit
    @exercises = Exercise.all
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to calendar_path(@calendar), notice: 'Schedule was successfully updated.'
    else
      @exercises = Exercise.all
      render :edit
    end
  end

  def destroy
    @schedule.destroy
    redirect_to calendar_path(@calendar), notice: 'Schedule was successfully deleted.'
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_schedule
    @schedule = @calendar.schedules.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:date, :exercise_id, :repetitions, :duration)
  end
end