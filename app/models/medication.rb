class Medication < ApplicationRecord
  validates :substance, :dosage, :unit, presence: true
  enum :unit, 'mg': 0, 'g': 1, 'mg/ml': 2
end
