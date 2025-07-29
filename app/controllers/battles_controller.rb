class BattlesController < ApplicationController
  include CardsHelper

  before_action :set_dungeon, only: %i[new]
  before_action :set_battle, only: [:show, :play]

  MAX_DECK_SIZE = Battle::MAX_DECK_SIZE

  def new
    return redirect_to dungeon_select_path, alert: "ダンジョンを選択してください" unless @dungeon

    session[:dungeon_id] = @dungeon.id

    @max_deck_size = MAX_DECK_SIZE
    # 枚数 > 0 の手持ちカードをビューに渡す
    @user_cards = current_user.user_cards.where("quantity > 0")
  end

  def start_investigation
    user_cards = current_user.user_cards.where('quantity > 0')
    selected_deck = params[:deck]&.to_unsafe_h || {}
    deck = []

    selected_deck.each do |card_id_str, qty_str|
      card_id = card_id_str.to_i
      qty = qty_str.to_i
      user_card = user_cards.find_by(card_id: card_id)
      next unless user_card && qty > 0 && qty <= user_card.quantity

      deck.concat([card_id] * qty)
    end

    if deck.empty?
      flash[:notice] = "デッキが空です。カードを選んでください。"
      return redirect_to new_battle_path
    end

    if deck.size > MAX_DECK_SIZE
      flash[:alert] = "デッキは最大#{MAX_DECK_SIZE}枚までです。"
      return redirect_to new_battle_path
    end

    # 構築したデッキをセッションに保存し、探索へ
    session[:base_deck] = deck
    session[:bonus_cards] = []
    redirect_to new_battle_investigate_path
  end

  def create
    base_deck = session[:base_deck] || []
    bonus_cards = session[:bonus_cards] || []
    full_deck = (base_deck + bonus_cards).shuffle

    if full_deck.size > MAX_DECK_SIZE
      flash[:alert] = "合計デッキ枚数が上限を超えています。"
      return redirect_to new_battle_path
    end

    # セッション初期化
    session[:base_deck] = nil
    session[:bonus_cards] = nil

    redirect_to battle_path(@battle)
  end

 def show
    # ▼▼▼ &. を使って @battle.dungeon が nil でもエラーにならないように修正 ▼▼▼
    if ["四則演算ダンジョン","法廷","双眸を為す"].include?(@battle.dungeon&.name)
      @current_weak_bunyas = [@battle.dungeon.rotating_weak_bunya(@battle.turn)]
    else
      # ▼▼▼ @battle.dungeon が nil の場合を考慮 ▼▼▼
      @current_weak_bunyas = @battle.dungeon&.weak_bunya.to_s.split(',').map(&:strip)
    end
  end

  def play
    card_id = params[:card_id].to_i
    correct = ActiveModel::Type::Boolean.new.cast(params[:correct])
    card = Card.find(card_id)
    dungeon = @battle.dungeon
    
    if correct
      current_user.solved_cards.find_or_create_by(card: card)
      @battle.log << "正解！"
      power = effective_power(card, current_user)
      case card.effect_type
      when 'attack'
        defence = dungeon&.boss_defence_power || 0

        damage = power

        if @battle.attack_boost
            damage = (damage * 1.5).floor
            @battle.attack_boost = false
            @battle.log << "防御の構えからの反撃！攻撃力が1.5倍になった！"
        end

        if dungeon
          weak = dungeon.weak_bunya.to_s.split(',')
          if ["四則演算ダンジョン","法廷","双眸を為す"].include?(dungeon.name)
            weak = [dungeon.rotating_weak_bunya(@battle.turn)]
          end
          if weak.include?(card.bunya)
            damage = (damage * 1.5).ceil
            @battle.log << "弱点を突いた！ダメージ1.5倍！"
          end
        end
        
        if damage <= defence
          # 防御力以下の場合：ダメージ半減（切り捨て）、最低1
          damage = [(damage / 2).floor, 1].max
          @battle.log << "ボスに防御された！ダメージが半減！"
        else
          damage = damage - defence
        end

        @battle.boss_hp -= damage
        @battle.log << "攻撃！ボスに#{damage}ダメージ"
      when 'defence'
        @defence = power
        @battle.attack_boost = true
        @battle.log << "防御！次の攻撃が強化される！"
      when 'heal'
        @battle.player_hp += power
        @battle.log << "回復！HPが#{power}回復"
      end
    else
      damage = rand(1..3)
      @battle.player_hp -= damage
      @battle.log << "不正解！#{damage}ダメージを受けた"
    end

    index = @battle.player_hand.index(card_id)
    @battle.player_hand.delete_at(index) if index

    #勝敗判定
    case gameover?
    when :victory
      @victory = true
      add_bonus_cards_to_user
       current_user.increment!(:gacha_points) # ポイントを1増やす
      flash[:notice] = "ダンジョンクリア！ガチャポイントを1獲得しました！"
      clear_no = @battle.dungeon_id + 1
      user    = current_user

      clear_dungeon(@battle.dungeon)
      
      session.delete(:dungeon_id)
      @battle.save!
      return render :show
    when :defeat
      @defeat = true
      session.delete(:dungeon_id)
      @battle.save!
      return render :show
    end

    boss_turn
    
    #勝敗判定その2
    case gameover?
    when :victory
      @victory = true
      add_bonus_cards_to_user
      clear_no = @battle.dungeon_id + 1
      user    = current_user

      clear_dungeon(@battle.dungeon)
      
      session.delete(:dungeon_id)
      @battle.save!
      return render :show
    when :defeat
      @defeat = true
      session.delete(:dungeon_id)
      @battle.save!
      return render :show
    end

    if @battle.player_hand.empty?
      @defeat = true
      session.delete(:dungeon_id)
      @battle.log << "デッキが尽きた…あなたは負けてしまった…"
      @battle.save!
      return render :show
    end

    # 手札補充
    while @battle.player_hand.size < 5 && @battle.deck.any?
      @battle.player_hand << @battle.deck.shift
    end

    @battle.turn += 1
    @battle.save!
    redirect_to battle_path(@battle)
  end

  private

  def set_dungeon
    @dungeon = Dungeon.find_by(id: params[:dungeon_id] || session[:dungeon_id])
    return if @dungeon

    redirect_to dungeon_select_path, alert: "先にダンジョンを選択してください"
  end

  def set_battle
    @battle = Battle.find(params[:id])
  end

  def gameover?
    return :defeat if @battle.player_hp <= 0
    return :victory if @battle.boss_hp <= 0
    false
  end

  def boss_turn
    dungeon = @battle.dungeon_id && Dungeon.find_by(id: @battle.dungeon_id)

    if @battle.boss_hp <= (dungeon&.boss_hp / 2) && rand < 0.3 #30%の確率で回復
      heal = [((dungeon&.boss_heal_power || 5) * rand(0.8..1.2)).to_i, 0].max #healpowerの0.8~1.2倍回復 初期healpower 5(for debug)
      @battle.boss_hp += heal
      @battle.log << "ボスが回復！#{heal}回復"
    else
      raw_damage = [((dungeon&.boss_attack_power || 5) * rand(0.8..1.2)).to_i, 0].max
      defence_value = @defence || 0
      reduced_damage = [raw_damage - defence_value, 0].max
      @battle.player_hp -= reduced_damage

      if defence_value > 0
        @battle.log << "防御の構え！-#{raw_damage - reduced_damage}軽減した！"
      end
      @battle.log << "ボスの攻撃！#{reduced_damage}ダメージ"

      @defence = 0
    end
  end

  def add_bonus_cards_to_user
    # return unless @battle.bonus_cards.is_a?(Array)

    @battle.bonus_cards.each do |card_id|
      user_card = current_user.user_cards.find_or_initialize_by(card_id: card_id)
      user_card.quantity ||= 0
      user_card.quantity += 1
      user_card.save!
    end
  end
  
  def clear_dungeon(dungeon)
    progress = current_user.dungeon_progress || {}
    level = dungeon.target_level.to_s
    current_order = progress[level].to_i

    if dungeon.order_in_level > current_order
      progress[level] = dungeon.order_in_level
      current_user.update!(dungeon_progress: progress)
    end
  end
end
