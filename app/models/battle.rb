class Battle < ApplicationRecord
  belongs_to :user

  serialize :deck, coder: YAML
  serialize :player_hand, coder: YAML
  serialize :log, coder: YAML
end
