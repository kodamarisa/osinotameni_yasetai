class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :calendar_users, as: :user
  has_many :calendars, through: :calendar_users
  has_many :bookmarks, dependent: :destroy
  has_one :customize, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true

  def guest?
    false
  end
end
