class Club < ApplicationRecord
  self.table_name = "clubs"

  validates :Club_Name, presence: true
  validates :Budget, numericality: { greater_than_or_equal_to: 0 }
end
