class CreateCustomizes < ActiveRecord::Migration[6.1]
  def change
    create_table :customizes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :line_user, foreign_key: true
      t.references :calendar, null: false, foreign_key: true

      t.timestamps
    end

    change_column :customizes, :line_user_id, :bigint, null: true
  end
end
