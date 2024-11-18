# app/models/equipment.rb
class Equipment < ApplicationRecord
  self.table_name = "equipments"  # Explicitly tell Rails the table name

  belongs_to :club, foreign_key: "Club_ID"
end
