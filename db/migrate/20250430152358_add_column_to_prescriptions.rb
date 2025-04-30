class AddColumnToPrescriptions < ActiveRecord::Migration[8.0]
  def change
    add_column :prescriptions, :user_type, :integer
  end
end
