class DungeonsController < ApplicationController
  def select
    allowed_ids = current_user.dungeon_numbers

    # ユーザーが持っているダンジョンだけ
    @dungeons = if allowed_ids.any?
                  Dungeon.where(id: allowed_ids)
                else
                  Dungeon.none
                end
  end
end
