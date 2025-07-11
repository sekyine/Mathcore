class CardsController < ApplicationController
  def answer
    card = Card.find(params[:card_id])
    correct = ActiveModel::Type::Boolean.new.cast(params[:correct])

    if correct
      SolvedCard.find_or_create_by!(user: current_user, card: card)
      # flash[:notice] = "正解！カード「#{card.bunya}」を解放しました。"
    else
      # flash[:notice] = "不正解…また挑戦してね！"
    end

    # redirect_back(fallback_location: root_path)
  end
end