class Club < ApplicationRecord
  self.table_name = "clubs"

  has_many :equipments, foreign_key: "Club_ID"
  has_many :financial_records, foreign_key: "Club_ID"
  belongs_to :parent_club, class_name: "Club", foreign_key: "Parent_Club", optional: true
end
