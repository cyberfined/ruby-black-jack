#!/usr/bin/env ruby
require_relative("game")
require_relative("tui")

tui = TUI.new
game = Game.new(tui)
game.game_loop
