class Card < ApplicationRecord
  has_many :user_cards
  has_many :users, through: :user_cards
<<<<<<< HEAD
end
=======
end
>>>>>>> usercard-display
