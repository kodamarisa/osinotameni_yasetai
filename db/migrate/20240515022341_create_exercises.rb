class CreateExercises < ActiveRecord::Migration[6.1]
  def change
    create_table :exercises do |t|
      t.string :name, null: false
      t.text :description, null: true
      t.integer :duration, null: true
      t.integer :difficulty, null: true

      t.timestamps
    end
  end
end
