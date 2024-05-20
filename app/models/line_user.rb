class LineUser < ApplicationRecord
  has_many :calendars, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
 
  validates :line_user_id, presence: true, uniqueness: true
  validates :name, presence: true
end
