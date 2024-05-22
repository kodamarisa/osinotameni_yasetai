class AddDetailsToSchedules < ActiveRecord::Migration[6.1]
  def change
    add_column :schedules, :repetitions, :integer
    add_column :schedules, :duration, :integer
  end
end
