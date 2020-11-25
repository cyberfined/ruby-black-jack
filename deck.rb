require_relative('card')

class Deck
  def initialize
    @deck = Card::TYPES.product(Card::SUITS).map { |t, s| Card.new(t, s) }
  end

  def get_cards(num_cards)
    cards = []
    num_cards.times { cards << @deck.sample }
    cards
  end
end
