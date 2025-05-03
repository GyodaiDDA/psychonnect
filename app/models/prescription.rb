class Prescription < ApplicationRecord
  belongs_to :patient, class_name: "User"
  belongs_to :physician, class_name: "User"
  belongs_to :medication
  validates :quantity, :time, presence: true

  enum :action_type, new_medication: 0, new_time: 2, increase_dosis: 4, reduce_dosis: 6, no_changes: 8, remove_medication: 10
end
