class Calendar < ApplicationRecord
  belongs_to :user, polymorphic: true

  has_many :calendar_users, dependent: :destroy
  has_many :users, through: :calendar_users, source: :user, source_type: 'User'
  has_many :line_users, through: :calendar_users, source: :user, source_type: 'LineUser'
  has_many :guest_users, through: :calendar_users, source: :user, source_type: 'GuestUser'
  has_many :schedules, dependent: :destroy

  validates :title, presence: true
end
