class UserCardsController < ApplicationController
  def index
    unless logged_in?
      redirect_to root_path, alert: "ログインしてください"
      return
    end

    @user_cards = current_user.user_cards.includes(:card).order("cards.st")
  end
end
