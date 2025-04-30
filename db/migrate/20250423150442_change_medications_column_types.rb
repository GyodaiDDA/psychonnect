class ChangeMedicationsColumnTypes < ActiveRecord::Migration[8.0]
  def change
    change_column :medications, :unit, :string
  end
end
