class DecksController < ApplicationController
    def show
        @deck = current_user.decks.find(params[:id])
        @deck_cards = @deck.deck_cards.includes(:card).order(:position)
    end
end

class DeckCardsController < ApplicationController
    def create
        deck = current_user.decks.find(params[:deck_id])
        card = Card.find(params[:card_id])
        deck.deck_cards.create(card: card, position: deck.deck_cards.count + 1)
        redirect_to deck_path(deck)
    end

    def destory
        deck_card = DeckCard.find(params[:id])
        deck = deck_card.deck
        deck_card.destroy
        redirect_to deck_path(deck)
    end
end