class CreateMedications < ActiveRecord::Migration[8.0]
  def change
    create_table :medications do |t|
      t.string :substance
      t.float :dosage
      t.string :measure

      t.timestamps
    end
  end
end
