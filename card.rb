class Card
  attr_reader :type, :suit

  SUITS = ["♠", "♥", "♦", "♣"]
  FACES = ["J", "Q", "K", "A"]
  NUMS  = ("2".."10").to_a

  def initialize(type, suit)
    @type = type
    @suit = suit
  end

  def to_s
    "#{@type} #{@suit}"
  end
end
