class CreatePrescriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :prescriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :medication, null: false, foreign_key: true
      t.integer :action_type
      t.float :quantity
      t.string :time
      t.text :comment

      t.timestamps
    end
  end
end
