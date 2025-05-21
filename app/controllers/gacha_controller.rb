class GachaController < ApplicationController
  def draw
    @card = Card.order("RANDOM()").first
  end
end
