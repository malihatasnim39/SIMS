class Borrowing < ApplicationRecord
  belongs_to :equipment, foreign_key: "equipment_id", class_name: "Equipment"
  belongs_to :club, foreign_key: "club_id", class_name: "Club"
  belongs_to :person_in_charge, class_name: "UserData", foreign_key: "pic_id", optional: true

  validates :equipment_id, :club_id, :borrow_date, :due_date, presence: true
  validates :status, inclusion: { in: %w[borrowed returned overdue] }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_save :ensure_due_date_is_date

  private

  def ensure_due_date_is_date
    self.due_date = due_date.to_date if due_date.present?
  end
end
