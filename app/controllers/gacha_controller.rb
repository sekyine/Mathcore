class GachaController < ApplicationController
  before_action :check_gacha_points, only: [:redraw]

  ALLOWED_BUNYA_BY_LEVEL = {
    1 => %w[足し算 引き算 掛け算 割り算 大きな数 かんたんな小数 かんたんな分数 かんたんな図形],
    2 => %w[比例・反比例 小数 分数 図形],
    3 => %w[方程式 連立方程式 二次方程式 平方根 一次関数 確率],
    4 => %w[一次不等式 二次関数 複素数 指数・対数 三角関数 微分 積分 極限 数列 ベクトル 確率]
  }.freeze

  # drawアクションはガチャを引くページを表示する役割のみ
  def draw
    # ここでは何も処理せず、app/views/gacha/draw.html.erb を表示する
  end

  # redrawアクションでガチャの抽選と結果表示を行う
  def redraw
    # ポイント消費処理
    current_user.decrement!(:gacha_points, 1)
    
    
    @card = pull_gacha
     # app/views/gacha/redraw.html.erb を表示する
  end

  # ▼▼▼ draw_tenアクションを追加 ▼▼▼
  def draw_ten
    @cards = []
    100.times do
      @cards << pull_gacha
    end
    # app/views/gacha/draw_ten.html.erb を表示する
  end
  # ▲▲▲ ここまで追加 ▲▲▲

  private

  def check_gacha_points
    # 10連ガチャかどうかで必要なポイント数を判断
    required_points = (action_name == 'draw_ten') ? 10 : 1
    
    # ▼▼▼ gacha_pointsがnilの場合に0として扱うように修正 ▼▼▼
    current_points = current_user.gacha_points || 0

    unless current_points >= required_points
      redirect_to gacha_draw_path, alert: "ガチャポイントが足りません（現在 #{current_points}ポイント）。ダンジョンをクリアしてポイントを貯めましょう！"
    end
  end
  # ガチャを引く共通ロジック
  # ▼▼▼ @cardへの代入をやめ、引いたカードを返すように変更 ▼▼▼
  def pull_gacha
    rates = { 1 => 70, 2 => 20, 3 => 5, 4 => 4, 5 => 1 }.freeze
    rarity = weighted_random(rates)

    allowed_level = current_user.math_level || 1 #学年別フィルタ
    allowed_bunya = ALLOWED_BUNYA_BY_LEVEL[allowed_level] || []
    cards = Card.where(st: rarity)
                .where(bunya: allowed_bunya)
    card = cards.sample

    if card && logged_in?
      user_card = current_user.user_cards.find_or_initialize_by(card: card)
      user_card.quantity ||= 0
      user_card.quantity += 1
      user_card.save!
    elsif card.nil?
      flash.now[:alert] = '該当するレアリティのカードが見つかりませんでした。'
    end
    
    return card # 引いたカードを返す
  end
  # ▲▲▲ ここまで変更 ▲▲▲

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