class Card
  attr_reader :type, :suit

  def initialize(type, suit)
    @type = type
    @suit = suit
    @str  = "#{@type} #{@suit}"
  end

  def to_s
    @str
  end
end
