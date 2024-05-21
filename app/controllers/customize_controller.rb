class CustomizeController < ApplicationController
  before_action :set_customize

  def edit
  end

  def update
    if @customize.update(customize_params)
      session[:calendar_color] = @customize.calendar_color
      redirect_to customize_edit_path, notice: 'Customization settings were successfully updated.'
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
