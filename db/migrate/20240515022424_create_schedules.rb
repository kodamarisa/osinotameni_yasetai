class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.references :calendar, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.date :date, null: false

      t.integer :repetitions
      t.integer :duration

      t.timestamps
    end
  end
end
