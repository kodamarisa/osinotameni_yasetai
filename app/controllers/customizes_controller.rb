class CustomizesController < ApplicationController
  before_action :set_customize, only: [:edit, :update]

  def new
    @customize = Customize.new
  end

  def create
    @customize = Customize.new(customize_params)
    @customize.user = current_user
  
    current_calendar_id = session[:current_calendar_id]
    calendar = Calendar.find_by(id: current_calendar_id)
  
    if calendar.nil?
      calendar = Calendar.create(title: "Default Calendar")
    end
  
    if current_user.guest?
      line_user = current_user.line_user
      @customize.line_user = line_user
    end
  
    @customize.calendar = calendar
  
    if @customize.save
      current_user.update(calendar: calendar)
      current_user.calendar.update(calendar_color: @customize.calendar_color)
      session[:calendar_color] = @customize.calendar_color
      redirect_to calendar_path(session[:current_calendar_id]), notice: 'Customization settings were successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @customize.update(customize_params)
      current_user.calendar.update(calendar_color: @customize.calendar_color)
      session[:calendar_color] = @customize.calendar_color
      session[:current_calendar_id] = current_user.calendar.id
      redirect_to calendar_path(current_user.calendar), notice: 'Customization settings were successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_customize
    @customize = Customize.find_or_initialize_by(user_id: current_user.id)
  end

  def customize_params
    params.require(:customize).permit(:calendar_color, :image)
  end
end
