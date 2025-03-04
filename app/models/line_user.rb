class LineUser < ApplicationRecord
  has_many :calendar_users, as: :user, dependent: :destroy
  has_many :calendars, through: :calendar_users, source: :calendar
  has_many :bookmarks, dependent: :destroy
 
  validates :line_user_id, presence: true, uniqueness: true
  validates :name, presence: true
end
