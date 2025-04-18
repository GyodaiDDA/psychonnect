class CreateMedications < ActiveRecord::Migration[8.0]
  def change
    create_table :medications do |t|
      t.string :substance
      t.float :dosage
      t.integer :unit

      t.timestamps
    end
  end
end
