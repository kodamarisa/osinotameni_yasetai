class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :line_user_id, null: false
      t.string :name, null: false
      t.string :profile_image_url, null: true
      t.string :access_token, null: true
      t.string :refresh_token, null: true

      t.timestamps
    end
    add_index :users, :line_user_id, unique: true
  end
end
