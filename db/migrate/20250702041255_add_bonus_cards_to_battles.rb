class AddBonusCardsToBattles < ActiveRecord::Migration[8.0]
  def change
    add_column :battles, :bonus_cards, :text
  end
end
