class User < ApplicationRecord
  has_many :user_cards
  has_many :cards, through: :user_cards
  
  has_many :solved_cards
  has_many :solved_card_objects, through: :solved_cards, source: :card

  has_many :battle_investigates
  attribute :dungeon_numbers, :json, default: ->{ [1] }
end
