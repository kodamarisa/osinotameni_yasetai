class Exercise < ApplicationRecord
   has_many :schedules, dependent: :destroy

   def self.ransackable_attributes(auth_object = nil)
      ["created_at", "description", "difficulty", "duration", "id", "name", "updated_at"]
    end
end
