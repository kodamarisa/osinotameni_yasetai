class ExercisesController < ApplicationController
  def index
    @calendar = Calendar.find_by(id: session[:current_calendar_id]) # カレンダーをセッションから取得
    unless @calendar
      flash[:alert] = 'カレンダーが見つかりません。'
      redirect_to calendars_path
      return
    end
  
    @q = Exercise.ransack(search_params)
    Rails.logger.debug "Search Parameters: #{search_params.inspect}"
    Rails.logger.debug "Query Result: #{@q.result.to_sql}"
  
    @exercises = @q.result
  end  

  def show
    @calendar = Calendar.find_by(id: session[:current_calendar_id]) # カレンダーをセッションから取得
    @exercise = Exercise.find(params[:id])
  end

  def autocomplete
    @exercises = Exercise.ransack(name_cont: params[:q]).result(distinct: true)
    render json: @exercises.pluck(:name)
  end

  private

  def search_params
    params.fetch(:q, {}).permit(:description_or_target_muscles_cont)
  end  
end
