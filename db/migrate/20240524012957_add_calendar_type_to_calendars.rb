class AddCalendarTypeToCalendars < ActiveRecord::Migration[6.1]
  def change
    add_column :calendars, :calendar_type, :string, null: true
  end
end
