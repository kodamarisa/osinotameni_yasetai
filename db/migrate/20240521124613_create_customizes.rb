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

  def down
    # Handle NULL values before disallowing them (if needed)
    # This might involve setting a default value or other logic
    # Customize.where(line_user_id: nil).update_all(line_user_id: 0) # Example placeholder, ensure this makes sense in your context

    # Disallow NULL values for line_user_id
    change_column :customizes, :line_user_id, :bigint, null: false

    drop_table :customizes
  end
end
