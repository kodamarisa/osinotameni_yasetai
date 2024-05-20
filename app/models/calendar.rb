class Calendar < ApplicationRecord
  has_many :calendar_users
  has_many :users, through: :calendar_users

  has_many :schedules, dependent: :destroy

  validates :title, presence: true
end
