class Player
  attr_reader :name, :money, :cards, :points

  def initialize(name, money)
    raise ArgumentError, "name must be non-empty string" if name == ""
    raise ArgumentError, "money must be non-negative" if money < 0

    @name = name
    @money = money
    @cards = []
  end

  def cards=(new_cards)
    @cards = new_cards
    calc_start_points
  end

  def append_card(card)
    @cards << card
    @points += card_points(card)
  end

  def money=(new_money)
    raise ArgumentError, "money must be non-negative" if new_money < 0
    @money = new_money
  end

  private

  def card_points(card)
    case card.type
    when "A"           then (@points + 11 <= 21) ? 11 : 1
    when "J", "Q", "K" then 10
    else               card.type
    end
  end

  def calc_start_points
    @points = 0
    @cards.each do |c|
      @points += card_points(c) unless c.type == "A"
    end
    @cards.each do |c|
      @points += card_points(c) if c.type == "A"
    end
  end
end
