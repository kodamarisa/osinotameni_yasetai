class ExercisesController < ApplicationController
  def index
    if params[:q].present?
      @exercises = Exercise.where("name LIKE ?", "%#{params[:q]}%")
    else
      @exercises = Exercise.all
    end
  end

  def show
    @exercise = Exercise.find(params[:id])
  end
end
