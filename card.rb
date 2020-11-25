class Card
  attr_reader :type, :suit

  SUITS = ['♠', '♥', '♦', '♣'].freeze
  TYPES = ('2'..'10').to_a + %w[J Q K A]

  def initialize(type, suit)
    @type = type
    @suit = suit
  end

  def to_s
    "#{@type} #{@suit}"
  end
end
