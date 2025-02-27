class SchedulesController < ApplicationController
  before_action :set_calendar
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  def new
    logger.debug "NEW: Params: #{params.inspect}"
    if params[:exercise_id].blank?
      logger.error "Exercise ID is missing in new action."
      redirect_to exercises_path, alert: 'エクササイズが指定されていません。' and return
    end
  
    @calendar = Calendar.find(params[:calendar_id])
    @exercise = Exercise.find(params[:exercise_id])
    @schedule = @calendar.schedules.build(exercise: @exercise)
    logger.debug "New Schedule initialized. Calendar: #{@calendar.inspect}, Exercise: #{@exercise.inspect}, Schedule: #{@schedule.inspect}"
  
    @exercises = Exercise.all
    @selected_exercise = @exercise
    @selected_date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def create
    logger.debug "CREATE: Params: #{params.inspect}"
    logger.debug "CREATE: calendar_id: #{params[:calendar_id]}" #calendar_idがリクエストに含まれているかを確認

    selected_date = params[:schedule][:date]
    if @calendar.schedules.where(date: selected_date).count >= 3
      flash[:alert] = 'その日にはこれ以上設定できません。'
      redirect_to exercises_path and return
    end

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
    logger.debug "INDEX: Params: #{params.inspect}"

    @calendar = Calendar.find(params[:calendar_id])
    @schedules = @calendar.schedules.includes(:exercise).where(date: params[:date])
    @exercises = Exercise.all
    logger.debug "Schedules retrieved: #{@schedules.inspect}"

    if params[:schedule_id]
      @selected_schedule = @schedules.find_by(id: params[:schedule_id])
      @selected_exercise = @selected_schedule&.exercise
    end

    respond_to do |format|
      format.html { render partial: 'schedules/schedule_details', locals: { schedules: @schedules, date: params[:date] } }
      format.js
    end
  end

  def edit
    logger.debug "EDIT: Params: #{params.inspect}"
    logger.debug "EDIT: Attempting to find schedule with ID: #{params[:id]} in calendar #{@calendar.id}"
  
    @schedule = Schedule.find_by(id: params[:id])
    if @schedule.nil?
      logger.error "EDIT: Schedule not found for ID: #{params[:id]}"
      render json: { error: "スケジュールが見つかりませんでした。" }, status: :not_found and return
    end

    @selected_exercise = @schedule.exercise  # 追加
    logger.info "EDIT: Schedule found: #{@schedule.inspect}"

    # 必要なデータをJSONで返す
    render json: {
      schedule_id: @schedule.id,
      exercise_id: @schedule.exercise_id,
      exercise_name: @selected_exercise.name,
      date: @schedule.date,
      repetitions: @schedule.repetitions,
      sets: @schedule.sets
    }
  end

  def update
    logger.debug "UPDATE: Schedule ID: #{@schedule.id}, Params: #{params.inspect}"
    logger.debug "UPDATE: Current Schedule Data: #{@schedule.inspect}"
  
    # exercise_idが空でないことを確認
    if params[:schedule][:schedule_exercise_id].blank?
      logger.error "Exercise ID is missing."
      render json: { status: 'error', message: 'エクササイズが指定されていません。' }, status: :unprocessable_entity
      return
    end

    # スケジュールを更新
    if @schedule.update(schedule_params)
      logger.info "Schedule updated: #{@schedule.inspect}"
      render json: { status: 'success', message: 'スケジュールが正常に更新されました。', schedule: @schedule }
    else
      logger.error "Failed to update schedule: #{@schedule.errors.full_messages}"
      render json: { status: 'error', errors: @schedule.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @schedule.destroy
      logger.info "Schedule successfully deleted: #{@schedule.id}"
      render json: { status: 'success' }, status: :ok
    else
      logger.error "Failed to delete schedule: #{@schedule.errors.full_messages}"
      render json: { status: 'error', errors: @schedule.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "カレンダーが見つかりませんでした。"
  end

  def set_schedule
    @schedule = @calendar.schedules.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    logger.error "Schedule not found for ID: #{params[:id]}"
    render json: { error: '指定されたスケジュールが見つかりませんでした。' }, status: :not_found
  end

  def schedule_params
    params.require(:schedule).permit(:calendar_id, :exercise_id, :name, :repetitions, :sets, :date)
  end
end