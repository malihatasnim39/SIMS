class UserData < ApplicationRecord
  has_many :borrowings, foreign_key: "pic_id"

  validates :id, presence: true
end
