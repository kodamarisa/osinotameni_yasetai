class BookmarksController < ApplicationController
  before_action :authenticate_user_or_line_user!
  before_action :set_exercise, only: [:create]
  before_action :set_bookmark, only: [:destroy]

  def index
    @bookmarks = current_user_or_line_user.bookmarks.includes(:exercise)
  end

  def create
    # 既にブックマークが存在するか確認
    if current_user_or_line_user.bookmarks.exists?(exercise_id: params[:exercise_id])
      respond_to do |format|
        format.js { render partial: 'already_bookmarked' } # 既にブックマークされている場合の処理
        format.json { render json: { status: 'already_bookmarked' }, status: :unprocessable_entity }
      end
    else
      @bookmark = current_user_or_line_user.bookmarks.create(exercise_id: params[:exercise_id])
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js   # JSレスポンスを追加
        format.json { render json: { status: 'created' } }
      end
    end
  end  

  def destroy
    @bookmark = current_user_or_line_user.bookmarks.find_by(exercise_id: params[:exercise_id])
    if @bookmark.present?
      @bookmark.destroy
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js   # JSレスポンスを追加
        format.json { render json: { status: 'deleted' } }
      end
    else
      redirect_to bookmarks_path, alert: 'Bookmark not found.'
    end
  end  

  private

  def set_exercise
    @exercise = Exercise.find(params[:exercise_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to exercises_path, alert: 'Exercise not found.'
  end

  def set_bookmark
    @bookmark = current_user_or_line_user.bookmarks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to bookmarks_path, alert: 'Bookmark not found.'
  end

  def current_user_or_line_user
    current_user || current_line_user
  end
end