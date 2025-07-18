class AddDifficultyLevelToCards < ActiveRecord::Migration[8.0]
  def change
    add_column :cards, :difficulty_level, :integer, default: 1, null: false
  end
end
