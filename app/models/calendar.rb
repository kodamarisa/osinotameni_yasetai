class Calendar < ApplicationRecord
  has_many :schebules, dependent: :destroy
end
