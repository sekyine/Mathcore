class CreateUserCards < ActiveRecord::Migration[8.0]
  def change
    create_table :user_cards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
