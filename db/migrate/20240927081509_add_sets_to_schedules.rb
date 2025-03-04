class AddSetsToSchedules < ActiveRecord::Migration[6.1]
  def change
    add_column :schedules, :sets, :integer, default: 1
  end
end
