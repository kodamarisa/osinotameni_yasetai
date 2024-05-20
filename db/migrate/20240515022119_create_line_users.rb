class CreateLineUsers < ActiveRecord::Migration[6.1]
    def change
        create_table :line_users do |t|
          t.string :line_user_id, null: false
          t.string :name, null: false
          t.string :profile_image_url
          t.string :access_token
          t.string :refresh_token
  
          t.timestamps
      end
      add_index :line_users, :line_user_id, unique: true
    end
  end