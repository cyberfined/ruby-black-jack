class TUI
  attr_writer :player, :dealer, :should_hide_dealer_info

  def initialize
    @should_hide_dealer_info = true
  end

  def dialog(message)
    print(message)
    $stdin.gets.chomp
  end

  def show_message(message)
    print("\n#{message}\n\n")
  end

  def choice_dialog(caption, choices)
    loop do
      puts(caption)
      choices.each_with_index { |c, i| puts "#{i + 1}) #{c}" }

      begin
        index = Integer($stdin.gets.chomp)
      rescue StandardError
        print("\nWrong input\n\n")
        next
      end

      if index < 1 || index > choices.length
        print("\nWrong input\n\n")
        next
      end
      index -= 1

      return choices[index]
    end
  end

  def yesno_dialog(caption)
    choice_dialog(caption, %w[Yes No]) == 'Yes'
  end

  def refresh
    if @should_hide_dealer_info
      str_dealer_cards = '*' * @dealer.cards.length
      str_dealer_points = '*'
    else
      str_dealer_cards = @dealer.cards.join(', ')
      str_dealer_points = @dealer.points.to_s
    end

    str_player_cards = @player.cards.join(', ')
    player_info = "Your cards: #{str_player_cards} | " \
                  "your points: #{@player.points} | " \
                  "your money: #{@player.money}"

    dealer_info = "Dealer's cards: #{str_dealer_cards} | " \
                  "dealer's points: #{str_dealer_points} | " \
                  "dealer's money: #{@dealer.money}"

    puts(`clear`)
    puts(player_info)
    puts(dealer_info)
  end
end
