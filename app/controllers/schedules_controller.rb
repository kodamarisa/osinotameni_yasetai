class SchedulesController < ApplicationController
  before_action :set_calendar
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  def new
    @calendar = Calendar.find(params[:calendar_id])
    @exercise = Exercise.find(params[:exercise_id]) # 引数からExerciseを取得
    @schedule = @calendar.schedules.build(exercise: @exercise) # @scheduleを初期化
  
    # 全てのExerciseを取得
    @exercises = Exercise.all
    @selected_exercise = @exercise # 選択中のエクササイズを設定
  
    # 追加: 選択した日付を設定
    @selected_date = params[:date] ? Date.parse(params[:date]) : Date.today
  end  

  def create
    @schedule = @calendar.schedules.build(schedule_params)
    
    if @schedule.save
      respond_to do |format|
        format.html { redirect_to calendar_path(@calendar), notice: 'スケジュールが正常に作成されました。' }
        format.js   # JavaScriptを使用してカレンダーを更新
      end
    else
      @exercises = Exercise.all
      render :new
    end
  end  

  def show
  end

  def index
    @date = params[:date]
    @calendar = Calendar.find(params[:calendar_id])
    @schedules = @calendar.schedules.where(date: @date)
  
    respond_to do |format|
      format.html { render partial: 'schedules/schedule_details', locals: { schedules: @schedules, date: @date } }
      format.js   # JavaScriptでのリクエストに対応
    end
  end  

  def edit
    @exercises = Exercise.all
  end  

  def update
    if @schedule.update(schedule_params)
      respond_to do |format|
        format.html { redirect_to calendar_path(@calendar), notice: 'スケジュールが正常に更新されました。' }
        format.js   # JavaScriptを使用してカレンダーを更新
      end
    else
      @exercises = Exercise.all
      render :edit
    end
  end

  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to calendar_path(@calendar), notice: 'スケジュールが正常に削除されました。' }
      format.js   # JavaScriptを使用してカレンダーを更新
    end
  end
  

  private

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_schedule
    @schedule = @calendar.schedules.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(:exercise_id, :repetitions, :sets, :date)
  end  
end