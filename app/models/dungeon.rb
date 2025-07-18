class Dungeon < ApplicationRecord
  has_many :battles
  enum :kind, { cave: 'cave', castle: 'castle',mount: 'mount',iseki: 'iseki',sougen: 'sougen' }


  def filtered_bunyas
    (card_bunya_filter || "").split(",").map(&:strip)
  end

  def rotating_weak_bunya(turn)
    return nil if weak_bunya.blank?

    bunyas = weak_bunya.split(',') # ["足し算", "引き算", ...]
    index = (turn - 1) % bunyas.length
    bunyas[index]
  end

end
