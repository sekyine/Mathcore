module CardsHelper
  def effective_power(card, user)
    user.solved_card_objects.include?(card) ? card.power : 1
  end

  def effective_power_with_base(card, user)
    effective = effective_power(card, user)
    if effective != card.power
      "#{card.power}（実際の効果: #{effective}）"
    else
      "#{card.power}"
    end
  end
end