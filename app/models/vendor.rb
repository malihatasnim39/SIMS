class Vendor < ApplicationRecord
  self.table_name = "vendors"
  validates :Name, presence: true
  validates :Address, presence: true
  validates :Phone_Number, presence: true, numericality: { only_integer: true }
end
