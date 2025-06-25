class User < ApplicationRecord
  has_many :user_cards
  has_many :cards, through: :user_cards

  has_many :battle_investigates
end
