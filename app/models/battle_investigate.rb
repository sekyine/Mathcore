class BattleInvestigate < ApplicationRecord
  belongs_to :user
  serialize :collected_cards, coder: JSON
end
