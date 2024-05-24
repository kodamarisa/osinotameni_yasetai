class Schedule < ApplicationRecord
  belongs_to :calendar
  belongs_to :exercise
  validates :date, presence: true

  def start_time
    self.date
  end
end
