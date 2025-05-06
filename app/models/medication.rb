class Medication < ApplicationRecord
  validates :substance, :dosage, :measure, presence: true
end
