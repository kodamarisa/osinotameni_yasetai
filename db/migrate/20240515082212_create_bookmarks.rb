class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :exercise, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
