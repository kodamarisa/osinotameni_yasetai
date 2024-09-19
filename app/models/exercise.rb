class Exercise < ApplicationRecord
   has_many :schedules, dependent: :destroy

   def self.ransackable_attributes(auth_object = nil)
      ["created_at", "description", "difficulty", "duration", "id", "name", "updated_at", "target_muscles"]
    end

  def self.ransackable_associations(auth_object = nil)
    [] # 今回はアソシエーションでの検索は許可しない
  end
end
