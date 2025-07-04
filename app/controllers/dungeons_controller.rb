class DungeonsController < ApplicationController
  def select
    # あなたのアプリに沿って「ダンジョン一覧」や「難易度」などを @dungeons に詰める
    allowed_ids = current_user.dungeon_numbers

    # ユーザーが持っているダンジョンだけ
    @dungeons = if allowed_ids.any?
                  Dungeon.where(id: allowed_ids)
                else
                  Dungeon.none
                end
  end
end
