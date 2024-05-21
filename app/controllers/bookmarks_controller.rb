class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise, only: [:create]
  before_action :set_bookmark, only: [:destroy]

  def index
    @bookmarks = current_user.bookmarks.includes(:exercise)
  end

  def create
    @bookmark = current_user.bookmarks.new(exercise: @exercise)

    if @bookmark.save
      redirect_to @exercise, notice: 'Exercise was successfully bookmarked.'
    else
      redirect_to @exercise, alert: 'Unable to bookmark exercise.'
    end
  end

  def destroy
    @bookmark.destroy
    redirect_back fallback_location: root_path, notice: 'Bookmark removed successfully'
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:exercise_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to exercises_path, alert: 'Exercise not found.'
  end

  def set_bookmark
    @bookmark = current_user.bookmarks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to bookmarks_path, alert: 'Bookmark not found.'
  end
end
