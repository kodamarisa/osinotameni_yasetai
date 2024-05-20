class CreateCalendarUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :calendar_users do |t|
      t.references :calendar, polymorphic: true, null: false
      t.references :user, polymorphic: true, null: false

      t.timestamps
    end
  end
end
