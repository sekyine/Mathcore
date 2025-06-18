class CreateBattles < ActiveRecord::Migration[8.0]
  def change
    create_table :battles do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :player_hp
      t.integer :boss_hp
      t.text :deck
      t.text :player_hand
      t.integer :turn
      t.text :log

      t.timestamps
    end
  end
end
