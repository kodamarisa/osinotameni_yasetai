class ExercisesController < ApplicationController
  def index
    logger.debug "INDEX: Current Calendar ID: #{session[:current_calendar_id]}"

    @calendar = Calendar.find_by(id: session[:current_calendar_id])
    unless @calendar
      logger.error "Calendar not found"
      flash[:alert] = 'カレンダーが見つかりません。'
      redirect_to calendars_path and return
    end

    @schedule = @calendar.schedules.new
    @q = Exercise.ransack(search_params)
    @exercises = @q.result
    logger.debug "Found Exercises: #{@exercises.map(&:name).join(', ')}"

    if current_user_or_line_user
      @bookmarked_exercise_ids = current_user_or_line_user.bookmarks.pluck(:exercise_id)
      logger.debug "Debug - Bookmarked Exercise IDs: #{@bookmarked_exercise_ids.inspect}"
    else
      @bookmarked_exercise_ids = []
    end
  end

  def show
    logger.debug "SHOW: Exercise ID: #{params[:id]}, Calendar ID: #{session[:current_calendar_id]}"

    @calendar = Calendar.find_by(id: session[:current_calendar_id])
    unless @calendar
      logger.error "Calendar not found"
      flash[:alert] = 'カレンダーが見つかりません。'
      redirect_to calendars_path and return
    end

    @exercise = Exercise.find_by(id: params[:id])
    unless @exercise
      logger.error "Exercise not found"
      flash[:alert] = '筋トレが見つかりません。'
      redirect_to exercises_path and return
    end

    @schedule = @calendar.schedules.new(exercise: @exercise)
    logger.debug "Initialized New Schedule for Exercise: #{@exercise.name}"

    if current_user_or_line_user
      @bookmarked_exercise_ids = current_user_or_line_user.bookmarks.pluck(:exercise_id)
      logger.debug "Debug - Bookmarked Exercise IDs: #{@bookmarked_exercise_ids.inspect}"
    else
      @bookmarked_exercise_ids = []
    end
  end

  private

  def search_params
    logger.debug "SEARCH PARAMS: #{params[:q].inspect}"
    params.fetch(:q, {}).permit(:description_or_target_muscles_cont)
  end
end