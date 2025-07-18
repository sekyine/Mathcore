class AddKindToDungeons < ActiveRecord::Migration[8.0]
  def change
    add_column :dungeons, :kind, :string
  end
end
