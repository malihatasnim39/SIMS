class NotificationHistory < ApplicationRecord
  belongs_to :notification

  validates :delivery_status, inclusion: { in: %w[success failed] }
  validates :delivery_method, presence: true
end
