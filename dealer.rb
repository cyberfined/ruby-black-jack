require_relative('player')
require_relative('game_actions')

class Dealer < Player
  def initialize(money)
    super('Dealer', money)
  end

  def next_turn
    return GameActions::PASS_ACTION if points >= 17 || cards.length > 2

    GameActions::GET_CARD_ACTION
  end
end
