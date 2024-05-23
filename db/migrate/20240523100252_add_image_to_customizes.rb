class AddImageToCustomizes < ActiveRecord::Migration[6.1]
  def change
    add_column :customizes, :image, :string
  end
end
