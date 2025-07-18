class ChangeDungeonNumbersToJson < ActiveRecord::Migration[8.0]
  def up
    remove_column :users, :dungeon_numbers, :text
    add_column    :users, :dungeon_numbers, :json, default: [1], null: false
  end

  def down
    remove_column :users, :dungeon_numbers, :json
    add_column    :users, :dungeon_numbers, :text, default: "[]", null: false
  end
end
