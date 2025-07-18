class AddTargetLevelToDungeons < ActiveRecord::Migration[8.0]
  def change
    add_column :dungeons, :target_level, :integer, default: 1, null: false
  end
end
