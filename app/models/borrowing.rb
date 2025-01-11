class Borrowing < ApplicationRecord
  belongs_to :equipment, foreign_key: "equipment_id", class_name: "Equipment"
  belongs_to :club, foreign_key: "club_id", class_name: "Club"
  belongs_to :person_in_charge, class_name: "UserData", foreign_key: "pic_id", optional: true

  # Constants to represent the enum values
  STATUSES = {
    borrowed: "borrowed",
    returned: "returned",
    overdue: "overdue"
  }.freeze

  # Validation for status
  validates :status, inclusion: { in: STATUSES.values }

  # Helper methods for enum-like behavior
  def borrowed?
    status == STATUSES[:borrowed]
  end

  def returned?
    status == STATUSES[:returned]
  end

  def overdue?
    status == STATUSES[:overdue]
  end

  def status_overdue!
    update!(status: STATUSES[:overdue])
  end
end
