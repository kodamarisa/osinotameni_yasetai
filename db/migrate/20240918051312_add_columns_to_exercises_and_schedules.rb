class AddColumnsToExercisesAndSchedules < ActiveRecord::Migration[6.1]
  def change
    # exercisesテーブルにカラムを追加
    add_column :exercises, :minimum_reps_or_distance, :integer
    add_column :exercises, :target_muscles, :string
    add_column :exercises, :is_cardio, :boolean, default: false

    # schedulesテーブルにdistanceカラムを追加
    add_column :schedules, :distance, :integer
  end
end
