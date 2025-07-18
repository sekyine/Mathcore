class Battle < ApplicationRecord
  belongs_to :user
  belongs_to :dungeon, optional: true
  
  serialize :deck, coder: YAML
  serialize :player_hand, coder: YAML
  serialize :log, coder: YAML
  serialize :bonus_cards, coder: YAML

  MAX_DECK_SIZE = 12 #デッキの最大枚数
end
