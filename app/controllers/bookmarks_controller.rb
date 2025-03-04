class BookmarksController < ApplicationController
  before_action :authenticate_user_or_line_user!
  before_action :set_calendar, only: [:index]
  before_action :set_exercise, only: [:create]
  before_action :set_bookmark, only: [:destroy]

  def index
    logger.debug "Index action: calendar_id = #{params[:calendar_id]}"
    @calendar = current_calendar
    @bookmarks = current_user_or_line_user.bookmarks.includes(:exercise)
    @bookmarked_exercise_ids = @bookmarks.pluck(:exercise_id)
    @schedule = Schedule.new
    @schedule.exercise ||= Exercise.new
    logger.debug "Bookmarks index: #{@bookmarks.map(&:exercise_id)}"
  end

  def create
    user = current_user_or_line_user
    Rails.logger.debug("Debug - current_user_or_line_user method: #{user.inspect}")

    if user.bookmarks.exists?(exercise_id: params[:exercise_id])
      logger.debug "Bookmark exists for exercise ID: #{params[:exercise_id]}"
      @exercise = Exercise.find(params[:exercise_id])
      render json: { status: 'already_bookmarked', icon: 'fas' }, status: :unprocessable_entity
    else
      @bookmark = user.bookmarks.create(exercise_id: params[:exercise_id])
      @exercise = @bookmark.exercise
      logger.debug "Response for bookmark toggle: #{ { status: 'created', icon: 'fas' }.to_json }"
      render json: { status: 'created', icon: 'fas' }
    end
  end

  def destroy
    if @bookmark.present?
      @bookmark.destroy
      render json: { status: 'deleted', icon: 'far' }
    else
      render json: { status: 'not_found' }, status: :not_found
    end
  end  

  private

  def set_calendar
    if params[:calendar_id].present?
      @calendar = Calendar.find_by(id: params[:calendar_id])
      unless @calendar
        logger.error "Calendar not found for ID: #{params[:calendar_id]}"
        redirect_to root_path, alert: '指定されたカレンダーが見つかりません。'
      end
    else
      logger.error "Calendar ID is missing."
      redirect_to root_path, alert: 'カレンダーが指定されていません。'
    end
  end

  def set_exercise
    @exercise = Exercise.find(params[:exercise_id])
  rescue ActiveRecord::RecordNotFound
    logger.error "Exercise not found for ID: #{params[:exercise_id]}"
    redirect_to exercises_path, alert: 'Exercise not found.'
  end

  def set_bookmark
    @bookmark = current_user_or_line_user.bookmarks.find_by(exercise_id: params[:exercise_id])
  rescue ActiveRecord::RecordNotFound
    logger.error "Bookmark not found for exercise ID: #{params[:exercise_id]}"
    redirect_to bookmarks_path, alert: 'Bookmark not found.'
  end
end