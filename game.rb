require_relative("game_actions")
require_relative("player")
require_relative("dealer")
require_relative("deck")
require_relative("card")

class Game
  RATE_SIZE     = 10
  BANK_SIZE     = 2*RATE_SIZE
  START_CAPITAL = 100

  def initialize(ui)
    @ui = ui
    @deck = Deck.new

    create_players
    @ui.player = @player
    @ui.dealer = @dealer

    # all allowed actions
    @actions = {
      GameActions::PASS_ACTION       => method(:pass_action),
      GameActions::GET_CARD_ACTION   => method(:get_card_action),
      GameActions::OPEN_CARDS_ACTION => method(:open_cards_action),
    }
  end

  def game_loop
    loop do
      new_game
      
      # main game loop
      until @should_end_round
        player_turn
        dealer_turn
        check_end_round_condition
        @ui.refresh
      end

      break unless summarize_game
    end

    @ui.show_message("Goodbye!")
  end

  private

  def new_game
    make_rates
    @player.cards = @deck.get_cards(2)
    @dealer.cards = @deck.get_cards(2)
    @ui.should_hide_dealer_info = true
    @ui.refresh
    @should_end_round = false
  end

  def summarize_game
    @ui.should_hide_dealer_info = false
    @ui.refresh

    player_delta = @player.points-21
    dealer_delta = @dealer.points-21

    if player_delta == dealer_delta
      caption = "You have a draw, do you want to restart"
      @player.money += RATE_SIZE
      @dealer.money += RATE_SIZE
    else
      if player_delta <= 0 && dealer_delta <= 0
        player_delta = player_delta.abs
        dealer_delta = dealer_delta.abs
      end

      winner = player_delta < dealer_delta ? @player : @dealer
      caption = "#{winner.name} won, do you want to restart?"
      winner.money += BANK_SIZE
    end

    @ui.yesno_dialog(caption)
  end

  def create_players
    player_name = @ui.dialog("Enter your name: ")
    @player = Player.new(player_name, START_CAPITAL)
    @dealer = Dealer.new(START_CAPITAL)
  rescue ArgumentError => e
    puts(e.message.capitalize)
    retry
  end

  def make_rates
    @player.money -= RATE_SIZE
    @dealer.money -= RATE_SIZE
  rescue
    @player.money = START_CAPITAL
    @dealer.money = START_CAPITAL
  end

  def player_turn
    loop do
      turn = @ui.choice_dialog("Your next action is:", GameActions::ACTIONS)
      break if action_call(@player, turn)
    end
  end

  def dealer_turn
    turn = @dealer.next_turn
    action_call(@dealer, turn)
  end

  def action_call(player, turn)
    action = @actions[turn]
    if action == nil
      @ui.show_message("undefined action #{turn}")
      return false
    end
    action.call(player)
  end

  def pass_action(player)
    true
  end

  def get_card_action(player)
    if player.cards.length >= 3
      @ui.show_message("#{player.name} can't get one more card") 
      return false
    end

    player.append_card(@deck.get_cards(1)[0])
    true
  end

  def open_cards_action(dummy)
    @should_end_round = true
  end

  def check_end_round_condition
    @should_end_round ||= @player.cards.length == 3 && @dealer.cards.length == 3
  end
end
