require_relative("player")
require_relative("game_actions")

class RealPlayer < Player
  def initialize(name, money, ui)
    super(name, money)
    @ui = ui
  end

  def next_turn
    @ui.choice_dialog("Your next turn is: ", GameActions::ACTIONS)
  end
end
