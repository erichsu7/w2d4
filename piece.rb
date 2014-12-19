require_relative 'board'

class IllegalMoveError < StandardError
end

class Piece

  attr_reader :color, :board, :symbol
  attr_accessor :pos, :king

  ALL_MOVE_DIRS = [
    [1, 1],
    [1, -1],
    [-1, 1],
    [-1, -1]
  ]

  def initialize(pos, board, color, king = false)
    @pos = pos
    @board = board
    @color = color
    @king = king
  end

  def symbol
    if king
      symbol = color == :black ? :♚ : :♔
    else
      symbol = color == :black ? :● : :○
    end

    @symbol = symbol
  end

  def maybe_promote
    case color
    when :black then self.king = true if pos[0] == 0
    when :white then self.king = true if pos[0] == 7
    end
  end

  def opposite_color
    color == :black ? :white : :black
  end

  def inspect
    symbol
  end

  def valid_moves
    return jump_moves unless jump_moves.empty?
    slide_moves
  end

  def perform_move(end_pos)
    if valid_moves == jump_moves
      move_type = :jump
      perform_jump(end_pos)
    elsif valid_moves == slide_moves
      move_type = :slide
      perform_slide(end_pos)
    end

    maybe_promote
    move_type
  end

  def perform_slide(end_pos)
    if slide_moves.include?(end_pos)
      start_pos = pos
      board[end_pos] = self
      self.pos = end_pos
      board[start_pos] = nil
      maybe_promote
      return true
    else
      raise IllegalMoveError.new("Not a valid move. Please try again.")
      false
    end
  end

  def perform_jump(end_pos)
    if jump_moves.include?(end_pos)
      start_pos = pos
      board[end_pos] = self
      self.pos = end_pos
      board[start_pos] = nil
      jumped_pos = (start_pos[0] + end_pos[0]) / 2, (start_pos[1] + end_pos[1]) / 2
      board[jumped_pos] = nil
      maybe_promote
      return true
    else
      raise IllegalMoveError, "Not a valid move. Please try again."
      false
    end
  end

  def slide_moves
    slide_moves = []
    self.move_dirs.each do |dir|
      row_offset, col_offset = dir
      new_pos = pos[0] + row_offset, pos[1] + col_offset
      next unless Board.on_board?(new_pos)

      slide_moves << new_pos.dup if board[new_pos].nil?
    end

    slide_moves
  end

  def jump_moves
    jump_moves = []

    move_dirs.each do |dir|
      jump_offset = dir[0] * 2, dir[1] * 2
      jump_move = pos[0] + jump_offset[0], pos[1] + jump_offset[1]
      adjacent_move = (pos[0] + jump_move[0]) / 2, (pos[1] + jump_move[1]) / 2

      next unless Board.on_board?(adjacent_move) && Board.on_board?(jump_move)
      next if board[adjacent_move].nil?

      if board[jump_move].nil? && board[adjacent_move].color == opposite_color
        jump_moves << jump_move.dup
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
