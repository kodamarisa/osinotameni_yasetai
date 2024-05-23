class Customize < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  belongs_to :user
  belongs_to :calendar
  belongs_to :line_user, optional: true

  validates :calendar_color, presence: true

end
