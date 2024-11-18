
class FinancialRecord < ApplicationRecord
  self.table_name = "financial_records"

  belongs_to :equipment, foreign_key: "Equipment_ID"
  belongs_to :vendor, foreign_key: "Vendor_ID"
end
