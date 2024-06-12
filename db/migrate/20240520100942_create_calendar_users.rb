class CreateCalendarUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :calendar_users do |t|
      t.references :calendar, null: false, foreign_key: true
      t.references :user, polymorphic: true, null: false
      t.timestamps
      t.index [:calendar_id, :user_id], unique: true
    end
  end
end
