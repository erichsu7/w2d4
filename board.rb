require_relative 'piece'

class Board

  attr_accessor :grid

  def initialize(populate = true)
    @grid = Array.new(8) { Array.new(8) }

    populate_board if populate
  end

  def self.on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def populate_board

    black_pieces_seed = {
      [7, 0] => Piece.new([7, 0], self, :black),
      [7, 2] => Piece.new([7, 2], self, :black),
      [7, 4] => Piece.new([7, 4], self, :black),
      [7, 6] => Piece.new([7, 6], self, :black),
      [6, 1] => Piece.new([6, 1], self, :black),
      [6, 3] => Piece.new([6, 3], self, :black),
      [6, 5] => Piece.new([6, 5], self, :black),
      [6, 7] => Piece.new([6, 7], self, :black),
      [5, 0] => Piece.new([5, 0], self, :black),
      [5, 2] => Piece.new([5, 2], self, :black),
      [5, 4] => Piece.new([5, 4], self, :black),
      [5, 6] => Piece.new([5, 6], self, :black)
    }

    white_pieces_seed = {
      [0, 1] => Piece.new([0, 1], self, :white),
      [0, 3] => Piece.new([0, 3], self, :white),
      [0, 5] => Piece.new([0, 5], self, :white),
      [0, 7] => Piece.new([0, 7], self, :white),
      [1, 0] => Piece.new([1, 0], self, :white),
      [1, 2] => Piece.new([1, 2], self, :white),
      [1, 4] => Piece.new([1, 4], self, :white),
      [1, 6] => Piece.new([1, 6], self, :white),
      [2, 1] => Piece.new([2, 1], self, :white),
      [2, 3] => Piece.new([2, 3], self, :white),
      [2, 5] => Piece.new([2, 5], self, :white),
      [2, 7] => Piece.new([2, 7], self, :white)
    }

    black_pieces_seed.each { |pos, piece| self[pos] = piece }
    white_pieces_seed.each { |pos, piece| self[pos] = piece }
  end


  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    grid[row][col] = piece
  end

  def render
    @grid.each do |row|
      row.each do |element|
        if element.is_a?(Piece)
          print element
          print "  "
        else
          print "_  "
        end
      end
      puts
    end
  end


end
