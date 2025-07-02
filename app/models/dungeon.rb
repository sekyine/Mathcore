class Dungeon < ApplicationRecord
  has_many :battles

  def filtered_bunyas
    (card_bunya_filter || "").split(",").map(&:strip)
  end
end
