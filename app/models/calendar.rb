class Calendar < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :calendar_users
  has_many :users, through: :calendar_users, source: :user, source_type: 'User'


  has_many :schedules, dependent: :destroy

  validates :title, presence: true
end
