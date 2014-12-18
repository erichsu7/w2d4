require_relative 'board'

class Piece

  attr_reader :color, :king, :board, :symbol

  ALL_MOVE_DIRS = [
    [1, 1],
    [1, -1],
    [-1, 1],
    [-1, -1]
  ]

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
    @king = false
  end

  def symbol
    if king
      @symbol = color == :black ? :♚ : :♔
    else
      @symbol = color == :black ? :● : :○
    end
  end

  def opposite_color
    color == :black ? :white : :black
  end

  def inspect
    symbol.to_s
  end

  def valid_moves
    return jump_moves unless jump_moves.nil? #player must make jump if available
    slide_moves
  end

  def slide_moves
    slide_moves = []
    move_dirs.each do |dir|
      row_offset, col_offset = dir
      new_pos = pos[0] + row_offset, pos[1] + col_offset
      next unless Board.on_board?(new_pos)

      slide_moves << new_pos if board[new_pos].nil?
    end

    slide_moves
  end

  def jump_moves
    jump_moves = []

    move_dirs.each do |dir|
      single_row_offset, single_col_offset = dir
      double_row_offset, double_col_offset = row_offset * 2, col_offset * 2
      adjacent_move = pos[0] + single_row_offset, pos[1] + single_col_offset
      jump_move = pos[0] + double_row_offset, pos[1] + double_col_offset

      next unless Board.on_board?(adjacent_move) && Board.on_board?(jump_move)
      next if board[adjacent_move].nil?

      if board[jump_move].nil? && board[adjacent_move].color == opposite_color
        jump_moves << jump_move
      end
    end

    jump_moves
  end

  def move_dirs
    move_dirs = ALL_MOVE_DIRS.select { |dir| dir[0] == -1 } if color == :black
    move_dirs = ALL_MOVE_DIRS.select { |dir| dir[0] == 1 } if color == :white
    move_dirs = ALL_MOVE_DIRS if king

    move_dirs
  end


end
