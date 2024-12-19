class Equipment < ApplicationRecord
  self.table_name = "equipments"
  belongs_to :club, foreign_key: "Club_ID"
  validates :Equipment_Name, presence: true
  validates :Financial_Record_Id, presence: true
  validates :Club_ID, presence: true
  validates :Vendor_ID, presence: true
end
