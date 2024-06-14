class GuestUser < ApplicationRecord
  has_one :calendar, as: :user, dependent: :destroy

  after_create :create_guest_calendar

  private

  def create_guest_calendar
    create_calendar!(title: "Guest Calendar")
  end
end
