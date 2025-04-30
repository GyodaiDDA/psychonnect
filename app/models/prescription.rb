class Prescription < ApplicationRecord
  belongs_to :patient, class_name: "User"
  belongs_to :physician, class_name: "User"
  belongs_to :medication
  validates :quantity, :time, :action_type, presence: true

  enum :action_type, new: 0, add: 1, sub: 2, remove: 10
end
