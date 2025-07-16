class DungeonsController < ApplicationController
  def select
    current_level = current_user.math_level
    progress = current_user.dungeon_progress || {}
    order = progress[current_level.to_s].to_i

    @dungeons = Dungeon.where(target_level: current_level)
                      .where("order_in_level <= ?", order + 1)
                      .order(:order_in_level)
  end
end
