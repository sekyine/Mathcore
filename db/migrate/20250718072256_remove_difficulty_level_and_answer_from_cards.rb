class RemoveDifficultyLevelAndAnswerFromCards < ActiveRecord::Migration[8.0]
  def change
    remove_column :cards, :difficulty_level, :integer
    remove_column :cards, :answer, :string
  end
end
