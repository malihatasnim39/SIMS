class UserData < ApplicationRecord
  self.table_name = "user_data"

  belongs_to :user, foreign_key: :id
  belongs_to :club, foreign_key: :club_id
end
