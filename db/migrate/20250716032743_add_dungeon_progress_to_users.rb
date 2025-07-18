class AddDungeonProgressToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :dungeon_progress, :json, default: {}, null: false
  end
end
