require_relative 'board'
require_relative 'player'

class Game

  attr_reader :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = Player.new(:black)
    @player2 = Player.new(:white)
  end

  def play

    while true
      turn(player1)
      break if board.won?(player1.color)
      turn(player2)
      break if board.won?(player2.color)
    end

    board.render
    puts "Game over!"
  end

  def turn(player)
    board.render
    player.play_turn(board)
    board.toggle_turn
  end
  
end

game = Game.new
game.play
