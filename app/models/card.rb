class Card < ApplicationRecord
  has_many :user_cards
  has_many :users, through: :user_cards

  has_many :solved_cards
end
