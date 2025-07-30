# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "csv"

CSV.foreach('db/cards.csv', headers: true) do |row|
  Card.create!(
    image: row["image"],
    st: row["st"],
    bunya: row["bunya"],
    ans: row["ans"],
    imans1: row["imans1"],
    imans2: row["imans2"],
    imans3: row["imans3"],
    effect_type: row["effect_type"],
    power: row["power"],
    question: row["question"]
  )
end

Dungeon.create!([ #card_bunya_filterとweak_bunyaはカンマ区切りで対応
  {
    name: "チュートリアル（小学校低学年）",
    description: "足し算だけ！(弱点:足し算)",
    boss_hp: 3,
    boss_attack_power: 1,
    boss_heal_power: 1,
    boss_defence_power: 0,
    weak_bunya: "足し算",
    card_bunya_filter: "足し算",
    target_level: 1,
    order_in_level: 1,
    kind:"cave"
  },
  {
    name: "四則演算ダンジョン",
    description: "足し算・引き算・掛け算・割り算が出題される(弱点:???)",
    boss_hp: 15,
    boss_attack_power: 3,
    boss_heal_power: 3,
    boss_defence_power: 0,
    weak_bunya: "足し算,引き算,掛け算,割り算",
    card_bunya_filter: "足し算,引き算,掛け算,割り算",
    target_level: 1,
    order_in_level: 2,
    kind:"castle"
  },
  {
    name: "イロンナカズ公園",
    description: "いろんな数が、君を羨ましそうに見ている...(弱点:かんたんな小数・かんたんな分数)",
    boss_hp: 20,
    boss_attack_power: 5,
    boss_heal_power: 3,
    boss_defence_power: 0,
    weak_bunya: "かんたんな小数,かんたんな分数",
    card_bunya_filter: "大きな数,かんたんな小数,かんたんな分数,かんたんな図形",
    target_level: 1,
    order_in_level: 3,
    kind:"sougen"
  },
  {
    name: "チュートリアル（小学校高学年）",
    description: "引き算・掛け算も登場！(弱点:引き算・掛け算)",
    boss_hp: 5,
    boss_attack_power: 5,
    boss_heal_power: 1,
    boss_defence_power: 0,
    weak_bunya: "引き算",
    card_bunya_filter: "引き算,掛け算",
    target_level: 2,
    order_in_level: 1,
    kind:"iseki"
  },
  {
    name: "ヒレイ山",
    description: "なんと険しい山でしょう...(弱点:比例・反比例)",
    boss_hp: 30,
    boss_attack_power: 5,
    boss_heal_power: 1,
    boss_defence_power: 0,
    weak_bunya: "比例・反比例",
    card_bunya_filter: "掛け算,割り算,比例・反比例",
    target_level: 2,
    order_in_level: 2,
    kind:"mount"
  },
  {
    name: "小数・分数サファリパーク",
    description: "いろんな動物が集るよ！(弱点:小数・分数)",
    boss_hp: 20,
    boss_attack_power: 5,
    boss_heal_power: 2,
    boss_defence_power: 8,
    weak_bunya: "小数,分数",
    card_bunya_filter: "小数,分数",
    target_level: 2,
    order_in_level: 3,
    kind:"sougen"
  },
  {
    name: "チュートリアル（中学生）",
    description: "分数や方程式が出るぞ！(弱点:二次方程式)",
    boss_hp: 20,
    boss_attack_power: 5,
    boss_heal_power: 1,
    boss_defence_power: 0,
    weak_bunya: "二次方程式",
    card_bunya_filter: "二次方程式,分数",
    target_level: 3,
    order_in_level: 1,
    kind:"cave"
  },
  {
    name: "法廷",
    description: "我々は罪を犯したのだ...(弱点:???)",
    boss_hp: 15,
    boss_attack_power: 10,
    boss_heal_power: 0,
    boss_defence_power: 15,
    weak_bunya: "方程式,連立方程式,二次方程式",
    card_bunya_filter: "方程式,連立方程式,二次方程式",
    target_level: 3,
    order_in_level: 2,
    kind:"iseki"
  },
  {
    name: "解放",
    description: "お勤めご苦労様でした。(弱点:かんたんな確率)",
    boss_hp: 70,
    boss_attack_power: 10,
    boss_heal_power: 12,
    boss_defence_power: 0,
    weak_bunya: "かんたんな確率",
    card_bunya_filter: "平方根,一次関数,かんたんな確率",
    target_level: 3,
    order_in_level: 3,
    kind:"mount"
  },
  {
    name: "チュートリアル（高校生）",
    description: "数学の世界へようこそ。",
    boss_hp: 25,
    boss_attack_power: 10,
    boss_heal_power: 10,
    boss_defence_power: 10,
    weak_bunya: "二次方程式",
    card_bunya_filter: "二次方程式,関数,ベクトル",
    target_level: 4,
    order_in_level: 1,
    kind:"mount"
  },
  {
    name: "夢想の境魔",
    description: "飛んでいる...(弱点:複素数)",
    boss_hp: 50,
    boss_attack_power: 30,
    boss_heal_power: 25,
    boss_defence_power: 0,
    weak_bunya: "複素数",
    card_bunya_filter: "一時不等式,二次関数,複素数",
    target_level: 4,
    order_in_level: 2,
    kind:"sougen"
  },
  {
    name: "教場の滲み",
    description: "冗長である。(弱点:三角関数・ベクトル)",
    boss_hp: 50,
    boss_attack_power: 10,
    boss_heal_power: 5,
    boss_defence_power: 20,
    weak_bunya: "三角関数,ベクトル",
    card_bunya_filter: "指数・対数,三角関数,確率,数列,ベクトル",
    target_level: 4,
    order_in_level: 3,
    kind:"castle"
  },
  {
    name: "双眸を為す",
    description: "瞼を閉じる。開く。また閉じる。(弱点:???)",
    boss_hp: 150,
    boss_attack_power: 10,
    boss_heal_power: 10,
    boss_defence_power: 0,
    weak_bunya: "微分,積分,極限",
    card_bunya_filter: "微分,積分,極限",
    target_level: 4,
    order_in_level: 4,
    kind:"mount"
  }
])