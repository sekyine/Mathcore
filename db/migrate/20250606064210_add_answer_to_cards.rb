class AddAnswerToCards < ActiveRecord::Migration[8.0]
  def change
    add_column :cards, :answer, :string
  end
end
