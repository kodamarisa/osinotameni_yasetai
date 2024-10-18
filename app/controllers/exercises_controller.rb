class ExercisesController < ApplicationController
  def index
    logger.debug "INDEX: Current Calendar ID: #{session[:current_calendar_id]}"

    @calendar = Calendar.find_by(id: session[:current_calendar_id])
    unless @calendar
      logger.error "Calendar not found"
      flash[:alert] = 'カレンダーが見つかりません。'
      redirect_to calendars_path
      return
    end

    @q = Exercise.ransack(search_params)
    @exercises = @q.result
    logger.debug "Found Exercises: #{@exercises.map(&:name).join(', ')}"

    @exercise = @exercises.first if @exercises.any?
    @schedule = @calendar.schedules.new if @calendar
  end    

  def show
    logger.debug "SHOW: Exercise ID: #{params[:id]}, Calendar ID: #{session[:current_calendar_id]}"

    @calendar = Calendar.find_by(id: session[:current_calendar_id])
    @exercise = Exercise.find(params[:id])
    logger.debug "Showing Exercise: #{@exercise.name}"
  end

  def autocomplete
    logger.debug "AUTOCOMPLETE: Query: #{params[:q]}"

    @exercises = Exercise.ransack(name_cont: params[:q]).result(distinct: true)
    logger.debug "Autocomplete Results: #{@exercises.map(&:name).join(', ')}"

    render json: @exercises.pluck(:name)
  end

  private

  def search_params
    logger.debug "SEARCH PARAMS: #{params[:q].inspect}"
    params.fetch(:q, {}).permit(:description_or_target_muscles_cont)
  end  
end