class Notification < ApplicationRecord
  belongs_to :borrowing
  has_many :notification_histories, dependent: :destroy

  validates :message, presence: true
  validates :status, inclusion: { in: %w[pending delivered resent] }
  validates :triggered_at, presence: true

  after_create_commit :enqueue_delivery_job

  private

  def enqueue_delivery_job
    NotificationDeliveryJob.perform_later(self.id)
  end

  after_update :log_history

  private

  def log_history
    NotificationHistory.create(
      notification_id: self.id,
      message: self.message,
      status: self.status,
      triggered_at: Time.current
    )
  end
end
