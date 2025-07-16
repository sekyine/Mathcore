# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Card.create(image: 'test1.png', st: 1, bunya: "足し算", question: "2+3=", ans: '5', imans1: '4', imans2: '6', imans3: '8',effect_type:"attack" ,power:2)
Card.create(image: 'test2.png', st: 1, bunya: "整数", question: "7-4=", ans: '3', imans1: '2', imans2: '4', imans3: '5',effect_type:"defence" ,power:2)
Card.create(image: 'test3.png', st: 2, bunya: "二次方程式", question: "ax^2+bx+c=0(a≠0)の解を求めよ",ans: '正解', imans1: '不正解', imans2: '誤答', imans3: '間違い', effect_type:"attack" ,power:5)
Card.create(image: 'test4.png', st: 1, bunya: "引き算", question: "13-8=", ans: '5', imans1: '8', imans2: '3', imans3: '6',effect_type:"defence" ,power:1)
Card.create(image: 'test5.png', st: 3, bunya: "連立方程式", question: "{█(3x+2y=3@4x+3y=4)┤の解を求めなさい", ans: 'x=1,y=0', imans1: 'x=0,y=1', imans2: 'x=1,y=1', imans3: 'x=1,y=-1',effect_type:"heal" ,power:2)

Dungeon.create!([ #card_bunya_filterとweak_bunyaは機能してないっす
  {
    name: "チュートリアルダンジョン",
    description: "はじめての方向け練習ダンジョン(弱点:足し算)",
    boss_hp: 10,
    boss_attack_power: 2,
    boss_heal_power: 2,
    boss_defence_power: 0,
    weak_bunya: "足し算",
    card_bunya_filter: "足し算,引き算",
    kind:"cave"
  },
  {
    name: "四則演算ダンジョン",
    description: "足し算・引き算・掛け算・割り算が出題される(弱点:???)",
    boss_hp: 20,
    boss_attack_power: 3,
    boss_heal_power: 3,
    boss_defence_power: 0,
    weak_bunya: "足し算,引き算,掛け算,割り算",
    card_bunya_filter: "足し算,引き算,掛け算,割り算",
    kind:"castle"
  },
  {
    name: "分数マスター",
    description: "分数の計算問題にチャレンジ！(弱点:分数)",
    boss_hp: 3,
    boss_attack_power: 20,
    boss_heal_power: 25,
    boss_defence_power: 1,
    weak_bunya: "分数",
    card_bunya_filter: "分数",
    kind:"castle"
  }
])