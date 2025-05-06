class User < ApplicationRecord
  # Users x Prescriptions
  has_many :received_prescriptions, class_name: "Prescription", foreign_key: :patient_id
  has_many :given_prescriptions, class_name: "Prescription", foreign_key: :physician_id

  # Physicians have patients
  has_many :physician_patients, foreign_key: :physician_id
  has_many :patients, through: :physician_patients

  # Patients have physicians
  has_many :patient_physicians, class_name: "PhysicianPatient", foreign_key: :patient_id
  has_many :physicians, through: :patient_physicians

  # Auth and validation
  has_secure_password
  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: %w[admin patient physician], message: "%{value} is not a valid role" }

  enum :role, patient: 0, physician: 1, blocked: 9, admin: 10
end
