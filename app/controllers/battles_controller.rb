class BattlesController < ApplicationController
  before_action :set_battle, only: [:show, :play]

  def new
    @battle = Battle.new
  end

  def create
    user_cards = current_user.user_cards.where('quantity > 0')
    selected_deck = params[:deck]&.to_unsafe_h || {}
    deck = []
    
    selected_deck.each do |card_id_str, qty_str|
      card_id = card_id_str.to_i
      qty = qty_str.to_i
      user_card = current_user.user_cards.find_by(card_id: card_id)

      next unless user_card && qty > 0 && qty <= user_card.quantity

      deck.concat([card_id] * qty)
    end

    if deck.empty?
      flash[:notice] = "デッキが空です。カードを選んでください。"
      return redirect_to new_battle_path
    end

    if deck.size > Battle::MAX_DECK_SIZE
      flash[:alert] = "デッキは最大#{Battle::MAX_DECK_SIZE}枚までです。"
      return redirect_to new_battle_path
    end

    deck.shuffle!

    @battle = Battle.create!(
      user: current_user,
      player_hp: 100,
      boss_hp: 1,
      deck: deck,
      player_hand: deck.shift(5),
      turn: 1,
      log: ["バトル開始！"]
    )
    if @battle.player_hand == []
      flash[:notice] = "デッキが無いよ！！！"
      return redirect_to root_path
    end
    redirect_to battle_path(@battle)
  end

  def show
    # 表示用
  end
  
  def gameover? #勝敗判定
    if @battle.player_hp <= 0
      flash[:alert] = "あなたは負けてしまった..."
      return true
    elsif @battle.boss_hp <= 0
      flash[:notice] = "ボスを倒した！勝利！"
      return true
    end
    false
  end

  def play
    card_id = params[:card_id].to_i
    card = Card.find(card_id)

    # カードの効果処理
    case card.effect_type
    when 'attack'
      @battle.boss_hp -= card.power
      @battle.log << "攻撃！ボスに#{card.power}ダメージ"
    when 'defend'
      @battle.log << "防御！次に受けるダメージが-#{card.power}される"
    when 'heal'
      @battle.player_hp += card.power
      @battle.log << "回復！HPが#{card.power}回復"
    end

    # カードの削除
    index = @battle.player_hand.index(card_id)
    @battle.player_hand.delete_at(index) if index
    
    if gameover?
      return redirect_to root_path
    end

    boss_turn
    if @battle.player_hand == []
      flash[:notice] = "デッキが無くなってしまった...あなたは負けた..."
      return redirect_to root_path
    elsif gameover?
      return redirect_to root_path
    end

    # 手札補充 (not working!!)
    # while @battle.player_hand.size < 5 && @battle.deck.any?
    #  @battle.player_hand << @battle.deck.shift
    # end
    
    @battle.turn += 1
    @battle.save!

    redirect_to battle_path(@battle)
  end

  private

  def set_battle
    @battle = Battle.find(params[:id])
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
