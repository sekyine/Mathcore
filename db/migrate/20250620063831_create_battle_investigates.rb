class CreateBattleInvestigates < ActiveRecord::Migration[8.0]
  def change
    create_table :battle_investigates do |t|
      t.references :user, null: false, foreign_key: true
      t.text :collected_cards

      t.timestamps
    end
  end
end
