class Exercise < ApplicationRecord
   has_many :schedules, dependent: :destroy
end
