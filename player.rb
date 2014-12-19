require 'io/console'
require_relative 'board'

class Player

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_turn(board, start_pos = nil)
    jump_piece_positions = get_jump_piece_positions(board)

    unless jump_piece_positions.empty?
      start_pos = get_start_position(board)
      until jump_piece_positions.include?(start_pos)
        start_pos = get_start_position(board)
      end
    end

    start_pos ||= get_start_position(board)
    begin
      end_pos = get_end_position(board)
      move_type = board[start_pos].perform_move(end_pos)
    rescue IllegalMoveError => error
      start_pos = get_start_position(board, error.message)
      start_pos = end_pos if move_type == :jump
      retry
    end

    if move_type == :jump
      play_next_jump(board, end_pos)
    end
  end

  def get_jump_piece_positions(board)
    player_pieces = board.pieces(color)
    jump_pieces = player_pieces.select { |piece| !piece.jump_moves.empty? }
    jump_pieces.map { |piece| piece.pos }
  end

  def play_next_jump(board, start_pos)
    while !board[start_pos].jump_moves.empty?
      begin
        end_pos = get_end_position(board)
        board[start_pos].perform_jump(end_pos)
      rescue IllegalMoveError => error
        retry
      end
      start_pos = end_pos
    end
  end

  def get_start_position(board, error_prompt = "")
    start_prompt = "Select piece to move with spacebar. w-a-s-d move cursor."
    input = get_input(board, start_prompt, error_prompt)

    if board[input].nil? || board[input].color != self.color
      error_prompt = "That's not your piece!"
      get_start_position(board, error_prompt)
    else
      input
    end
  end

  def get_end_position(board)
    end_prompt = "Select where to move piece with spacebar. w-a-s-d move cursor."
    input = get_input(board, end_prompt)
  end

  def get_input(board, prompt = "", error_prompt = "")
    command = nil
    until command == " "
      system('clear')
      board.render
      puts "#{board.current_turn} turn"
      puts prompt
      puts error_prompt
      unless board[board.cursor_pos].nil?
        piece = board[board.cursor_pos]
        p "Valid moves: #{piece.valid_moves}"
        p "Position: #{piece.pos}"
        p "Cursor pos: #{board.cursor_pos}"
        p "King status: #{piece.king}"
      end

      command = STDIN.getch
      p "Command: #{command}"
      case command
      when 'w' then board.cursor_pos[0] -= 1 unless board.cursor_pos[0] - 1 < 0
      when 's' then board.cursor_pos[0] += 1 unless board.cursor_pos[0] + 1 > 7
      when 'a' then board.cursor_pos[1] -= 1 unless board.cursor_pos[1] - 1 < 0
      when 'd' then board.cursor_pos[1] += 1 unless board.cursor_pos[1] + 1 > 7
      when 'q' then exit
      end
    end

    board.cursor_pos.dup
  end


end
