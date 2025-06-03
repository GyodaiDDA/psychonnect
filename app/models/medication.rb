# Model represents a medication prescribed
# to a patient, with uniqueness validations
# for the combo substance+uniqueness
class Medication < ApplicationRecord
  validates :substance, :dosage, :measure, presence: true
  validates :substance, uniqueness: { scope: :dosage, message: I18n.t('api.error.uniqueness') }
end
