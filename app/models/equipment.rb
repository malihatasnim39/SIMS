class Equipment < ApplicationRecord
  self.table_name = "equipments"

  belongs_to :financial_record, foreign_key: "Financial_Record_Id"
  belongs_to :club, foreign_key: "Club_ID"
  belongs_to :vendor, foreign_key: "Vendor_ID"

  validates :Equipment_Name, presence: true
  validates :Financial_Record_Id, presence: true
  validates :Club_ID, presence: true
  validates :Vendor_ID, presence: true
end
