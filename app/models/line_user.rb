class LineUser < ApplicationRecord
  has_many :calendar_users, as: :user
  has_many :calendars, through: :calendar_users

  has_many :bookmarks, dependent: :destroy
 
  validates :line_user_id, presence: true, uniqueness: true
  validates :name, presence: true
end
