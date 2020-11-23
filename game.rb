require_relative("game_actions")
require_relative("real_player")
require_relative("dealer")
require_relative("card")

class Game
  RATE_SIZE     = 10
  BANK_SIZE     = 2*RATE_SIZE
  START_CAPITAL = 100

  def initialize(ui)
    @ui = ui

    create_players
    @ui.player = @player
    @ui.dealer = @dealer

    create_deck

    # all allowed actions
    @actions = {
      GameActions::PASS_ACTION       => method(:pass_action),
      GameActions::GET_CARD_ACTION   => method(:get_card_action),
      GameActions::OPEN_CARDS_ACTION => method(:open_cards_action),
    }
  end

  def game_loop
    should_end_game = false

    until should_end_game
      # restore from previous game
      make_rates
      @player.cards = generate_cards(2)
      @dealer.cards = generate_cards(2)

      @ui.should_hide_dealer_info = true
      @ui.refresh
      
      cur_player_index = 0
      @should_end_round = false

      # main game loop
      until @should_end_round
        cur_player = @players[cur_player_index]
        next_turn(cur_player)
        @ui.refresh

        check_end_round_condition
        cur_player_index = 1 - cur_player_index
      end

      # open cards

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

      should_end_game = !@ui.yesno_dialog(caption)
    end

    @ui.show_message("Goodbye!")
  end

  private

  def create_players
    player_name = @ui.dialog("Enter your name: ")
    @player = RealPlayer.new(player_name, START_CAPITAL, @ui)
    @dealer = Dealer.new(START_CAPITAL)
    @players = [@player, @dealer]
  rescue ArgumentError => e
    puts(e.message.capitalize)
    retry
  end

  def create_deck
    suit = ["♠", "♥", "♦", "♣"]
    faces = ["J", "Q", "K", "A"]
    @deck = []

    for i in 2..10
      suit.each {|s| @deck << Card.new(i, s)}
    end

    faces.each do |f|
      suit.each {|s| @deck << Card.new(f, s)}
    end
  end

  def make_rates
    @player.money -= RATE_SIZE
    @dealer.money -= RATE_SIZE
  rescue
    @player.money = START_CAPITAL
    @dealer.money = START_CAPITAL
  end

  def next_turn(cur_player)
    loop do
      turn = cur_player.next_turn
      action = @actions[turn]
      if action == nil
        @ui.show_message("undefined action #{turn}")
        next
      end

      break if action.call(cur_player)
    end
  end

  def pass_action(player)
    true
  end

  def get_card_action(player)
    if player.cards.length >= 3
      @ui.show_message("#{player.name} can't get one more card") 
      return false
    end

    player.append_card(generate_card)
    true
  end

  def open_cards_action(dummy)
    @should_end_round = true
  end

  def generate_card
    @deck.sample
  end

  def generate_cards(num_cards)
    cards = []
    num_cards.times {cards << generate_card}
    cards
  end

  def check_end_round_condition
    @should_end_round ||= @player.cards.length == 3 && @dealer.cards.length == 3
  end
end
