class ChangeGachaPointsDefaultInUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :gacha_points, from: nil, to: 3
  end
end
