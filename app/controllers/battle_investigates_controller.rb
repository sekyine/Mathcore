class BattleInvestigatesController < ApplicationController
  before_action :set_investigation

  def new
    @card = Card.order("RANDOM()").limit(3)
  end

  def set_investigation
    @investigation = current_user.battle_investigates.where('created_at >= ?', 30.minutes.ago).last ||
    current_user.battle_investigates.create(collected_cards: [], turn_count: 0)
  end

  def answer
    card = Card.find(params[:card_id])
    correct = ActiveModel::Type::Boolean.new.cast(params[:correct])

    if correct
      @investigation.collected_cards << card.id
      flash[:notice] = "正解！カード「#{card.bunya}」をゲット！"

      session[:bonus_cards] ||= []
      session[:bonus_cards] << card.id
    else
      flash[:alert] = "不正解..."
    end

    @investigation.turn_count ||= 0
    @investigation.turn_count += 1
    @investigation.save!

    if @investigation.turn_count >= 3
      base_deck = session[:base_deck] || []
      bonus_cards = session[:bonus_cards] || []
      full_deck = (base_deck + bonus_cards).shuffle

      battle = Battle.create!(
        user: current_user,
        player_hp: 100,
        boss_hp: 1,
        deck: full_deck,
        player_hand: full_deck.shift(5),
        turn: 1,
        log: ["バトル開始！"]
      )

      @investigation.turn_count = 0
      @investigation.save!

      session.delete(:base_deck)
      session.delete(:bonus_cards)

      redirect_to battle_path(battle) and return
    end
    redirect_to new_battle_investigate_path
  end
end
