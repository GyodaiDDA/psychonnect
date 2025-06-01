# Model for users including three categories:
# physicians, patients and admins
class User < ApplicationRecord
  # Users x Prescriptions
  has_many :received_prescriptions, class_name: 'Prescription', foreign_key: :patient_id, dependent: nil,
                                    inverse_of: :prescriptions
  has_many :given_prescriptions, class_name: 'Prescription', foreign_key: :physician_id, dependent: nil,
                                 inverse_of: :prescriptions

  # Physicians have patients
  has_many :physician_patients, foreign_key: :physician_id, dependent: nil,
                                inverse_of: :none
  has_many :patients, through: :physician_patients, dependent: nil,
                      inverse_of: :none

  # Patients have physicians
  has_many :patient_physicians, class_name: 'PhysicianPatient', foreign_key: :patient_id, dependent: nil,
                                inverse_of: :none
  has_many :physicians, through: :patient_physicians, dependent: nil,
                        inverse_of: :none

  # Auth and validation
  has_secure_password
  validates :name, presence: true, on: :create
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, on: :create
  #validates :role, inclusion: { in: %[admin patient physician], message: '%<value>s is not a valid role' }

  enum :role, patient: 0, physician: 1, blocked: 9, admin: 10
end
