class CreateCustomizes < ActiveRecord::Migration[6.1]
  def change
    create_table :customizes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :line_user, foreign_key: true, null: true
      t.references :calendar, null: false, foreign_key: true
      t.string :calendar_color
      t.string :image

      t.timestamps
    end
  end
end
