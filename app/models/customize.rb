class Customize < ApplicationRecord
  belongs_to :user
  belongs_to :line_user
  belongs_to :calendar
end
