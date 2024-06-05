class CreateCalendars < ActiveRecord::Migration[6.1]
  def change
    create_table :calendars do |t|
      t.string :title, null: false
      t.string :image, null: true
      t.string :calendar_color, null: true
      t.string :calendar_type

      t.timestamps
    end
  end
end
