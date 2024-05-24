class CustomizesController < ApplicationController
  before_action :set_customize, only: [:edit, :update]
  before_action :authenticate_user_or_line_user!

  def new
    @customize = Customize.new
  end

  def create
    @customize = Customize.new(customize_params)
  
    if line_user_signed_in?
      @customize.line_user = current_line_user
    end
  
    current_calendar_id = session[:current_calendar_id]
    calendar = Calendar.find_by(id: current_calendar_id)
  
    if calendar.nil?
      calendar = Calendar.create(title: "Default Calendar")
    end
  
    @customize.calendar = calendar
  
    if @customize.save
      if current_user
        current_user.update(calendar: calendar)
        current_user.calendar.update(calendar_color: @customize.calendar_color)
      elsif current_line_user
        current_line_user.update(calendar: calendar)
        current_line_user.calendar.update(calendar_color: @customize.calendar_color)
      end
      session[:calendar_color] = @customize.calendar_color
      redirect_to calendar_path(session[:current_calendar_id]), notice: 'Customization settings were successfully created.'
    else
      render :new
    end
  end

  def show
    @schedule = Schedule.find(params[:id])
  end

  def edit
  end

  def update
    if @customize.update(customize_params)
      if current_user
        current_user.calendar.update(calendar_color: @customize.calendar_color)
        session[:calendar_color] = @customize.calendar_color
        session[:current_calendar_id] = current_user.calendar.id
      elsif current_line_user
        current_line_user.calendar.update(calendar_color: @customize.calendar_color)
        session[:calendar_color] = @customize.calendar_color
        session[:current_calendar_id] = current_line_user.calendar.id
      end
      redirect_to calendar_path(current_user&.calendar || current_line_user&.calendar), notice: 'Customization settings were successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_customize
    if user_signed_in?
      @customize = Customize.find_or_initialize_by(user_id: current_user.id)
    elsif line_user_signed_in?
      @customize = Customize.find_or_initialize_by(line_user_id: current_line_user.id)
    else
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  def customize_params
    params.require(:customize).permit(:calendar_color, :image)
  end
end
