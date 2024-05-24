class AddCalendarColorToCustomizes < ActiveRecord::Migration[6.1]
  def change
    add_column :customizes, :calendar_color, :string
  end
end
