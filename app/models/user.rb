class User
  include ActiveModel::Model

  attr_accessor :email, :password, :password_confirmation

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true, if: -> { password.present? }
  validate :password_match

  private

  def password_match
    if password.present? && password_confirmation.present? && password != password_confirmation
      errors.add(:password_confirmation, "doesn't match Password")
    end
  end
end
