class Club < ApplicationRecord
  self.table_name = "clubs"

  has_many :equipments, foreign_key: "Club_ID"
end
