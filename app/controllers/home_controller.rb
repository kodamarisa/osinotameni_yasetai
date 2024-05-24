class HomeController < ApplicationController
  def index
    if current_user && current_user.calendar_id.present?
      redirect_to calendar_path(current_user.calendar_id)
    else
      redirect_to root_path
    end
  end
end
