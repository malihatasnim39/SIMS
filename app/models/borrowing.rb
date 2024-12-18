class Borrowing < ApplicationRecord
  belongs_to :equipment, optional: true
  belongs_to :club, optional: true

  before_save :set_due_date

  delegate :name, to: :equipment, prefix: true, allow_nil: true

  private

  def set_due_date
    if predefined_duration.present?
      case predefined_duration
      when "Last Week"
        self.due_date = borrow_date + 7.days
      when "Last Month"
        self.due_date = borrow_date + 1.month
      when "Last Year"
        self.due_date = borrow_date + 1.year
      else
        self.due_date = borrow_date
      end
    else
      self.due_date = end_date
    end
  end
end
