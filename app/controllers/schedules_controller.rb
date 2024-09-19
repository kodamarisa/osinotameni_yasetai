class SchedulesController < ApplicationController
  before_action :set_calendar
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  def new
    @calendar = Calendar.find(params[:calendar_id])
    @schedule = @calendar.schedules.build
    @exercises = Exercise.all
    @selected_exercise = Exercise.find(params[:exercise_id]) if params[:exercise_id].present?
  end

  def create
    @schedule = Calendar.find(params[:calendar_id])
    @schedule = @calendar.schedules.build(schedule_params)

    if @schedule.save
      respond_to do |format|
        format.html { redirect_to calendar_path(@calendar), notice: 'Schedule was successfully created.' }
        format.js   # Use JavaScript to handle modal closing and calendar updating
      end
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

  def schedule_params
    params.require(:schedule).permit(:date, :exercise_id, :repetitions, :duration)
  end
end