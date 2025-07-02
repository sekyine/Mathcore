class CreateSolvedCards < ActiveRecord::Migration[8.0]
  def change
    create_table :solved_cards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
