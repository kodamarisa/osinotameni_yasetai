class CalendarUser < ApplicationRecord
  belongs_to :user, polymorphic: true
  belongs_to :calendar
end
