# Relational table to associate physicians and
# patients, regulating that relation's status
class PhysicianPatient < ApplicationRecord
  belongs_to :physician, class_name: 'User'
  belongs_to :patient, class_name: 'User'

  validates :physician_id, uniqueness: { scope: :patient_id }
  validate :roles_are_valid

  private

  def roles_are_valid
    errors.add(:physician, 'Esse usuário precisa ser um médico') unless physician&.physician?
    errors.add(:patient, 'Esse usuário precisa ser um médico') unless patient&.patient?
  end

  enum :status, active: 0, inactive: 10
end
