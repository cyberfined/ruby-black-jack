require_relative('hand')

class Player
  attr_reader :name, :money

  def initialize(name, money)
    raise ArgumentError, 'name must be non-empty string' if name == ''
    raise ArgumentError, 'money must be non-negative' if money.negative?

    @name = name
    @money = money
    @hand = Hand.new
  end

  def points
    @hand.points
  end

  def cards
    @hand.cards
  end

  def cards=(new_cards)
    @hand.cards = new_cards
  end

  def money=(new_money)
    raise ArgumentError, 'money must be non-negative' if new_money.negative?

    @money = new_money
  end
end
