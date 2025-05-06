class CreatePhysicianPatients < ActiveRecord::Migration[8.0]
  def change
    create_table :physician_patients do |t|
      t.references :physician, null: false, foreign_key: { to_table: :users }
      t.references :patient, null: false, foreign_key: { to_table: :users }
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :physician_patients, [ :physician_id, :patient_id ], unique: true
  end
end
