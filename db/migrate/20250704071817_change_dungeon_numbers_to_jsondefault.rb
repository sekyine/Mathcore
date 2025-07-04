class ChangeDungeonNumbersToJsondefault < ActiveRecord::Migration[8.0]
  def up
    # デフォルトを [] → [1] に変更
    change_column_default :users, :dungeon_numbers, from: [], to: [1]
    # 既存レコードに対しては強制的に初期値をセット（必要に応じて）
    execute <<-SQL.squish
      UPDATE users
      SET dungeon_numbers = '[1]'
      WHERE dungeon_numbers = '[]';
    SQL
  end

  def down
    change_column_default :users, :dungeon_numbers, from: [1], to: []
    execute <<-SQL.squish
      UPDATE users
      SET dungeon_numbers = '[]'
      WHERE dungeon_numbers = '[1]';
    SQL
  end
end
