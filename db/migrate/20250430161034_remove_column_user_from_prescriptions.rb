class RemoveColumnUserFromPrescriptions < ActiveRecord::Migration[8.0]
  def change
    remove_reference :prescriptions, :user, null: false, foreign_key: true
  end
end
