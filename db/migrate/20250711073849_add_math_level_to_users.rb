class AddMathLevelToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :math_level, :integer, default: 1, null: false
  end
end
