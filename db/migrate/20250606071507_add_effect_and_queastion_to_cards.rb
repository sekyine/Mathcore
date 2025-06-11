class AddEffectAndQueastionToCards < ActiveRecord::Migration[8.0]
  def change
    add_column :cards, :effect_type, :string
    add_column :cards, :power, :integer
    add_column :cards, :question, :string
  end
end
