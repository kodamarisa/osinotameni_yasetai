class SchedulesController < ApplicationController
  before_action :set_calendar
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  def new
    @schedule = @calendar.schedules.build
    @exercises = Exercise.all
  
    logger.debug "Rendering new schedule form"
    logger.debug "Calendar: #{@calendar.inspect}"
    logger.debug "Schedule: #{@schedule.inspect}"
    logger.debug "Exercises: #{@exercises.inspect}"
  
    respond_to do |format|
      format.html # default behavior
      format.json { render json: { html: render_to_string(partial: 'schedules/form', formats: [:html], locals: { calendar: @calendar, schedule: @schedule, exercises: @exercises }) } }
    end
  end

  def create
    @schedule = @calendar.schedules.build(schedule_params)

    if @schedule.save
      respond_to do |format|
        format.html { redirect_to calendar_path(@calendar), notice: 'Schedule was successfully created.' }
        format.json { render json: { redirect_url: calendar_path(@calendar) }, status: :created }
      end
    else
      @exercises = Exercise.all
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { html: render_to_string(partial: 'schedules/form', locals: { calendar: @calendar, schedule: @schedule, exercises: @exercises }) }, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    @exercises = Exercise.all
    respond_to do |format|
      format.html
      format.json { render json: { html: render_to_string(partial: 'schedules/form', locals: { calendar: @calendar, schedule: @schedule, exercises: @exercises }) } }
    end
  end

  def update
    if @schedule.update(schedule_params)
      respond_to do |format|
        format.html { redirect_to calendar_path(@calendar), notice: 'Schedule was successfully updated.' }
        format.json { render json: { redirect_url: calendar_path(@calendar) }, status: :ok }
      end
    else
      @exercises = Exercise.all
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { html: render_to_string(partial: 'form', locals: { calendar: @calendar, schedule: @schedule, exercises: @exercises }) }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @schedule.destroy
    redirect_to calendar_path(@calendar), notice: 'Schedule was successfully deleted.'
  end

  private

  def set_calendar
    @calendar = Calendar.find_by(id: params[:calendar_id])
    unless @calendar
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end

  def set_schedule
    @schedule = @calendar.schedules.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:date, :exercise_id, :repetitions, :duration)
  end
end