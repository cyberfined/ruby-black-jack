class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def points
    points = 0
    @cards.each { |c| points += card_points(points, c) unless c.type == 'A' }
    @cards.each { |c| points += card_points(points, c) if c.type == 'A' }
    points
  end

  private

  def card_points(points, card)
    case card.type
    when 'A'           then points + 11 <= 21 ? 11 : 1
    when 'J', 'Q', 'K' then 10
    else               card.type.to_i
    end
  end
end
