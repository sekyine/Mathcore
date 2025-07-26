class AddAttackBoostToBattles < ActiveRecord::Migration[8.0]
  def change
    add_column :battles, :attack_boost, :boolean
  end
end
