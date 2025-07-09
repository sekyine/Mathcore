class AddDungeonIdToBattles < ActiveRecord::Migration[8.0]
  def change
    add_column :battles, :dungeon_id, :integer
  end
end
