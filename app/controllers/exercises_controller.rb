class ExercisesController < ApplicationController
  def index
    @q = Exercise.ransack(params[:q])
    @exercises = @q.result
  end

  def show
    @exercise = Exercise.find(params[:id])
  end

  def autocomplete
    @exercises = Exercise.ransack(name_cont: params[:q]).result(distinct: true)
    render json: @exercises.pluck(:name)
  end
end
