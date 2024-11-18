class Vendor < ApplicationRecord
  self.table_name = "vendors"  # Adjust this to match your actual table name

  has_many :equipments, foreign_key: "Vendor_ID"
  has_many :financial_records, foreign_key: "Vendor_ID"
end
