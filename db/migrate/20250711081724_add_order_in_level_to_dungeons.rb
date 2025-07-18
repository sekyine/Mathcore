class AddOrderInLevelToDungeons < ActiveRecord::Migration[8.0]
  def change
    add_column :dungeons, :order_in_level, :integer
  end
end
