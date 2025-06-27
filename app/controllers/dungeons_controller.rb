class DungeonsController < ApplicationController
  def select
    # あなたのアプリに沿って「ダンジョン一覧」や「難易度」などを @dungeons に詰める
    @dungeons = Dungeon.all # モデル名はお好みで
  end
end
