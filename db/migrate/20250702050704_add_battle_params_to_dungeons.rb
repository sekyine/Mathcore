class AddBattleParamsToDungeons < ActiveRecord::Migration[8.0]
  def change
    add_column :dungeons, :boss_hp, :integer
    add_column :dungeons, :boss_attack_power, :integer
    add_column :dungeons, :boss_heal_power, :integer
    add_column :dungeons, :boss_defence_power, :integer
    add_column :dungeons, :weak_bunya, :string
    add_column :dungeons, :card_bunya_filter, :string
  end
end
