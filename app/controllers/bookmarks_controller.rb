class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @exercise = Exercise.find(params[:exercise_id])
    @bookmark = current_user.bookmarks.new(exercise: @exercise)

    if @bookmark.save
      redirect_to @exercise, notice: 'Exercise was successfully bookmarked.'
    else
      redirect_to @exercise, alert: 'Unable to bookmark exercise.'
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @bookmark.destroy
    redirect_back fallback_location: root_path, notice: 'Bookmark removed successfully'
  end
end
