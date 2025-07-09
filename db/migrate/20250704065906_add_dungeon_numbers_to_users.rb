class AddDungeonNumbersToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users,
               :dungeon_numbers,
               :text,
               default: "[1]",
               null: false
  end
end
