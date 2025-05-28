class GachaController < ApplicationController
  def draw
    rates = { 1 => 70, 2 => 20, 3 => 5, 4 => 4, 5 => 1}.freeze #ガチャのレート

    rarity = weighted_random(rates)
    cards = Card.where(st: rarity) #stを指定して...
    @card = cards.sample #ランダムに選出

  end

  def weighted_random(weights)
    total = weights.values.sum #普通は100
    point = rand(total) #1~100からランダムに値を選ぶ
    current = 0

    weights.each do |key, weight| #選んだ値がある確率より下ならそれを返す
      current += weight #例えば、1=>70,2=>20として、point=88とすると、88 > 70, 88 < 90より、stは2となる
      return key if point < current
    end
  end
end
