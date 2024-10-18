class SchedulesController < ApplicationController
  before_action :set_calendar
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  def new
    logger.debug "NEW: Calendar ID: #{params[:calendar_id]}, Exercise ID: #{params[:exercise_id]}, Date: #{params[:date]}"
    
    @calendar = Calendar.find(params[:calendar_id])
    @exercise = Exercise.find(params[:exercise_id])
    @schedule = @calendar.schedules.build(exercise: @exercise)
  
    @exercises = Exercise.all
    @selected_exercise = @exercise
    @selected_date = params[:date] ? Date.parse(params[:date]) : Date.today
  end  

  def create
    logger.debug "CREATE: Params: #{params.inspect}"

    @schedule = @calendar.schedules.build(schedule_params)
    if @schedule.save
      logger.info "Schedule successfully created: #{@schedule.inspect}"
      render json: { status: 'success', schedule: @schedule }, status: :created
    else
      logger.error "Failed to create schedule: #{@schedule.errors.full_messages}"
      render json: { status: 'error', errors: @schedule.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    logger.debug "INDEX: Calendar ID: #{params[:calendar_id]}, Date: #{params[:date]}"

    @calendar = Calendar.find(params[:calendar_id])
    @schedules = @calendar.schedules.where(date: params[:date])
    @exercises = Exercise.all

    if params[:exercise_id]
      @exercise = Exercise.find(params[:exercise_id])
      logger.debug "Selected Exercise: #{@exercise.name}"
    end

    respond_to do |format|
      format.html { render partial: 'schedules/schedule_details', locals: { schedules: @schedules, date: params[:date] } }
      format.js
    end
  end

  def update
    logger.debug "UPDATE: Schedule ID: #{@schedule.id}, Params: #{params.inspect}"

    if @schedule.update(schedule_params)
      logger.info "Schedule updated: #{@schedule.inspect}"
      respond_to do |format|
        format.html { redirect_to calendar_path(@calendar), notice: 'スケジュールが正常に更新されました。' }
        format.js
      end
    else
      logger.error "Failed to update schedule: #{@schedule.errors.full_messages}"
      @exercises = Exercise.all
      render :edit
    end
  end

  def destroy
    logger.info "DESTROY: Schedule ID: #{@schedule.id}"

    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to calendar_path(@calendar), notice: 'スケジュールが正常に削除されました。' }
      format.js
    end
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
    logger.debug "Set Calendar: #{@calendar.inspect}"
  end

  def set_schedule
    @schedule = @calendar.schedules.find(params[:id])
    logger.debug "Set Schedule: #{@schedule.inspect}"
  end

  def schedule_params
    params.require(:schedule).permit(:exercise_id, :repetitions, :sets, :date)
  end
end