class Borrowing < ApplicationRecord
  belongs_to :equipment, foreign_key: "equipment_id", class_name: "Equipment"
  belongs_to :club, foreign_key: "club_id", class_name: "Club"
  belongs_to :person_in_charge, class_name: "UserData", foreign_key: "pic_id", optional: true

  validates :equipment_id, :club_id, :borrow_date, :due_date, :quantity, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :status, inclusion: { in: %w[borrowed returned overdue] }

  # Callbacks for stock management
  before_create :reduce_stock_on_borrow
  before_destroy :restore_stock_on_destroy

  # Callbacks for notifications
  after_create :create_borrowing_notification
  after_update :check_for_overdue_notification

  private

  def reduce_stock_on_borrow
    if equipment
      new_stock = equipment.stock - quantity
      raise ActiveRecord::RecordInvalid, "Insufficient stock for borrowing" if new_stock.negative?

      equipment.update!(stock: new_stock)
    end
  end

  def restore_stock_on_destroy
    equipment.update!(stock: equipment.stock + quantity) if equipment
  end

  # Notification logic
  def create_borrowing_notification
    Notification.create(
      borrowing_id: self.id,
      message: "#{equipment.name} borrowed by #{club.name} on #{borrow_date}.",
      status: "pending",
      triggered_at: Time.current
    )
  end

  def check_for_overdue_notification
    if status == "overdue" && !notifications.exists?(message: "#{equipment.name} is overdue.")
      Notification.create(
        borrowing_id: self.id,
        message: "#{equipment.name} is overdue by #{(Date.today - due_date).to_i} days.",
        status: "delivered",
        triggered_at: Time.current
      )
    end
  end
end
