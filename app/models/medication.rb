# Model represents a medication prescribed
# to a patient, with uniqueness validations
# for the combo substance+uniqueness
class Medication < ApplicationRecord
  validates :substance, :dosage, :measure, presence: true
  validates :substance, uniqueness: { scope: :dosage, message: I18n.t('api.error.uniqueness') }

  before_create :check_uniqueness
  
  private
  
  def check_uniqueness
    if Medication.exists?(substance: substance, dosage: dosage)
      errors.add(:base, I18n.t('api.error.uniqueness'))
      throw :abort
    end
  rescue ActiveRecord::RecordNotUnique => e
    errors.add(:base, I18n.t('api.error.uniqueness'))
    throw :abort
  end
end
