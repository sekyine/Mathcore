class BattlesController < ApplicationController
  before_action :set_battle, only: [:show, :play]

  MAX_DECK_SIZE = Battle::MAX_DECK_SIZE

  def new
    # デッキ構築画面
    @max_deck_size = MAX_DECK_SIZE
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

    # @battle = Battle.create!( #今はbattle_investigation_controller
    #   user: current_user, #にてパラメータを弄ってます
    #   player_hp: 100, 
    #   boss_hp: 1,
    #   deck: full_deck,
    #   player_hand: full_deck.shift(5),
    #   turn: 1,
    #   log: ["バトル開始！"]
    # )

    # セッション初期化
    session[:base_deck] = nil
    session[:bonus_cards] = nil

    redirect_to battle_path(@battle)
  end

  def show
    # バトル画面
  end

  def play
    card_id = params[:card_id].to_i
    correct = ActiveModel::Type::Boolean.new.cast(params[:correct])
    card = Card.find(card_id)

    if correct
      current_user.solved_cards.find_or_create_by(card: card)
      @battle.log << "正解！"
    else
      @battle.log << "不正解！"
      damage = rand(1..3)
      @battle.player_hp -= damage
      @battle.log << "#{damage}ダメージを受けた"
    end
    
    case card.effect_type
    when 'attack'
      @battle.boss_hp -= card.power
      @battle.log << "攻撃！ボスに#{card.power}ダメージ"
    when 'defence'
      @battle.log << "防御！次に受けるダメージが-#{card.power}される"
    when 'heal'
      @battle.player_hp += card.power
      @battle.log << "回復！HPが#{card.power}回復"
    end
    
    index = @battle.player_hand.index(card_id)
    @battle.player_hand.delete_at(index) if index

    return redirect_to root_path if gameover?

    boss_turn

    if @battle.player_hand.empty?
      flash[:notice] = "デッキが無くなってしまった...あなたは負けた..."
      return redirect_to root_path
    elsif gameover?
      return redirect_to root_path
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

  def set_battle
    @battle = Battle.find(params[:id])
  end

  def gameover?
    if @battle.player_hp <= 0
      flash[:alert] = "あなたは負けてしまった..."
      return true
    elsif @battle.boss_hp <= 0
      flash[:notice] = "ボスを倒した！勝利！"
      return true
    end
    false
  end

  def boss_turn
    if @battle.boss_hp <= 80 && rand < 0.3
      heal = rand(10..25)
      @battle.boss_hp += heal
      @battle.log << "ボスが回復！#{heal}回復"
    else
      damage = rand(10..20)
      @battle.player_hp -= damage
      @battle.log << "ボスの攻撃！#{damage}ダメージ"
    end
  end
end
