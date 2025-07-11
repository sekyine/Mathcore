class BattleInvestigatesController < ApplicationController
  before_action :set_investigation

  def new
    dungeon = Dungeon.find_by(id: session[:dungeon_id])
    
    if dungeon && dungeon.card_bunya_filter.present?
      bunya_list = dungeon.card_bunya_filter.split(',').map(&:strip)
      # bunya_list に合致するカードを取得
      filtered_cards = Card.where(bunya: bunya_list)
      if filtered_cards.exists?
        @card = fetch_explore_cards_with_filter(filtered_cards, 3)
      else
        # 該当カードがなければランダムに3枚取得
        @card = fetch_explore_cards(3)
      end
    else
      # dungeonやfilterがなければランダムに3枚取得
      @card = fetch_explore_cards(3)
    end
  end

  def fetch_explore_cards(limit = 3)
    rates = { 1 => 70, 2 => 20, 3 => 5, 4 => 4, 5 => 1 }

    cards = []
    used_ids = []

    attempts = 0
    while cards.size < limit && attempts < 30 #フェイルセーフ(重複したカードが出たら何度でも(30回まで)引き直す)
      rarity = weighted_random(rates)
      rarity_cards = Card.where(st: rarity).where.not(id: used_ids)

      if rarity_cards.exists?
        card = rarity_cards.order("RANDOM()").first
        cards << card
        used_ids << card.id
      else
        fallback = Card.where.not(id: used_ids)
        if fallback.exists?
          card = fallback.order("RANDOM()").first
          cards << card
          used_ids << card.id
        end
      end

      attempts += 1
    end

    cards
  end

  def fetch_explore_cards_with_filter(filtered_scope, limit = 3)
    rates = { 1 => 70, 2 => 20, 3 => 5, 4 => 4, 5 => 1 }

    cards = []
    used_ids = []

    attempts = 0
    while cards.size < limit && attempts < 30 #フェイルセーフ
      rarity = weighted_random(rates)
      rarity_cards = filtered_scope.where(st: rarity).where.not(id: used_ids)

      if rarity_cards.exists?
        card = rarity_cards.order("RANDOM()").first
        cards << card
        used_ids << card.id
      else
        fallback = filtered_scope.where.not(id: used_ids)
        if fallback.exists?
          card = fallback.order("RANDOM()").first
          cards << card
          used_ids << card.id
        end
      end

      attempts += 1
    end

    cards
  end

  def weighted_random(weights)
    total = weights.values.sum
    point = rand(total)
    current = 0

    weights.each do |key, weight|
      current += weight
      return key if point < current
    end
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
      
      dungeon = Dungeon.find_by(id: session[:dungeon_id])

      battle = Battle.create!(
        user: current_user,
        player_hp: 100,
        boss_hp: dungeon&.boss_hp || 50, # デフォルト値あり
        deck: full_deck,
        player_hand: full_deck.shift(5),
        turn: 1,
        log: ["バトル開始！"],
        bonus_cards: session[:bonus_cards],
        dungeon_id: dungeon&.id
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
