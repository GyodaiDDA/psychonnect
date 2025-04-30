class User < ApplicationRecord
  has_secure_password
  validates :name, :email, :role, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  enum :role, patient: 0, physician: 1, admin: 10
end
