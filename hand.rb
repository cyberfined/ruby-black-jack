class Hand
  attr_reader :cards, :points

  def initialize
    @cards = []
    @points = 0
  end

  def append_card(card)
    @cards << card
    @points += card_points(card)
  end

  def cards=(new_cards)
    @cards = new_cards
    calc_points
  end

  private

  def calc_points
    @points = 0
    @cards.each {|c| @points += card_points(c) unless c.type == "A"}
    @cards.each {|c| @points += card_points(c) if c.type == "A"}
  end

  def card_points(card)
    case card.type
    when "A"           then (@points + 11 <= 21) ? 11 : 1
    when "J", "Q", "K" then 10
    else               card.type.to_i
    end
  end
end
