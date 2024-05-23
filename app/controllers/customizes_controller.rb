class CustomizesController < ApplicationController
  before_action :set_customize, only: [:edit, :update]

  def new
    @customize = Customize.new
  end

  def create
    @customize = Customize.new(customize_params)
    @customize.user = current_user

    if @customize.save
      redirect_to calendar_path(current_user.calendar), notice: 'Customization settings were successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @customize.update(customize_params)
      session[:calendar_color] = @customize.calendar_color
      redirect_to customizes_edit_path, notice: 'Customization settings were successfully updated.'
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
