class AddColumnsToPrescriptions < ActiveRecord::Migration[8.0]
  def change
    add_reference :prescriptions, :patient, null: false, foreign_key: {to_table: :users}
    add_reference :prescriptions, :physician, null: false, foreign_key: {to_table: :users}
  end
end
