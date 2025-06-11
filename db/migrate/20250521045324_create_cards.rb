class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :image
      t.integer :st
      t.string :bunya
      t.string :ans
      t.string :imans1
      t.string :imans2
      t.string :imans3

      t.timestamps
    end
  end
end
