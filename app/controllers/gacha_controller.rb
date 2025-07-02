class GachaController < ApplicationController
  # drawアクションはガチャを引くページを表示する役割のみ
  def draw
    # ここでは何も処理せず、app/views/gacha/draw.html.erb を表示する
  end

  # redrawアクションでガチャの抽選と結果表示を行う
  def redraw
    pull_gacha
    # app/views/gacha/redraw.html.erb を表示する
  end

  private

  # ガチャを引く共通ロジック
  def pull_gacha
    rates = { 1 => 70, 2 => 20, 3 => 5, 4 => 4, 5 => 1 }.freeze
    rarity = weighted_random(rates)
    cards = Card.where(st: rarity)
    @card = cards.sample

    if @card && logged_in?
      user_card = current_user.user_cards.find_or_initialize_by(card: @card)
      user_card.quantity ||= 0
      user_card.quantity += 1
      user_card.save!
    elsif @card.nil?
      flash.now[:alert] = '該当するレアリティのカードが見つかりませんでした。'
    end
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
end