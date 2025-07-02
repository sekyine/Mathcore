class AddTurnCountToBattleInvestigates < ActiveRecord::Migration[8.0]
  def change
    add_column :battle_investigates, :turn_count, :integer, default: 0
  end
end
