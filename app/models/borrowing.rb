# app/models/borrowing.rb
class Borrowing < ApplicationRecord
  # Custom getter for PostgreSQL enum
  def status
    read_attribute(:status)&.to_sym # Convert the database value to a symbol
  end

  # Custom setter for PostgreSQL enum
  def status=(value)
    write_attribute(:status, value.to_s) # Convert the symbol or string to a string
  end

  # Scopes for easy querying
  scope :borrowed, -> { where(status: "borrowed") }
  scope :returned, -> { where(status: "returned") }
  scope :overdue, -> { where(status: "overdue") }

  belongs_to :equipment, foreign_key: "equipment_id", optional: true
end
