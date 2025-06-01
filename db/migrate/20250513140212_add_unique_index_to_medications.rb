class AddUniqueIndexToMedications < ActiveRecord::Migration[8.0]
  def change
    add_index :medications, [:substance, :dosage], unique: true, name: 'index_medications_on_substance_and_dosage'
  end
end
