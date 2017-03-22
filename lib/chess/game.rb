require 'chess/board'
require 'chess/move'

class Game
  attr_reader :playing_side, :board, :ep_position

  def initialize
    @board = Board.new
    @ep_position = nil
    @playing_side = :white
  end

  def opposing_side
    @playing_side == :white ? :black : :white
  end

  def play(move, promotion_piece_type=nil)
    to_pos = move[1]
    deploy(move)
    promote(to_pos, promotion_piece_type) if promotion_piece_type != nil
    update_ep_position(move)
    end_turn
  end

  def deploy(move)
    board.move_piece(move)

    if Move::is_ep_capture?(move, self)
      board.remove_piece(@ep_position + Pawn::ep_capture_position_offset(@playing_side))
    end

    if Move::is_castling?(move, board)
      board.castle_rook(move)
    end
  end

  def promote(pos, promotion_piece_type)
    board.place_piece(pos, promotion_piece_type, playing_side)
  end

  def update_ep_position(move)
    if Move::is_pawn_double_advance?(move, board)
      @ep_position = (move[0] + move[1]) / 2
    else
      @ep_position = nil
    end
  end

  def end_turn
    @playing_side = opposing_side
  end

  def playing_side_in_check?
    board.attack_map(opposing_side)[board.king_position(playing_side)]
  end

  def checkmate?
    playing_side_in_check? && legal_moves == []
  end
  
  def stalemate?
    !playing_side_in_check? && legal_moves == []
  end
  
  def over?
    checkmate? || stalemate?
  end

  def legal_moves
    pseudolegal_moves.select do |move|
      leaves_king_safe?(move)
    end
  end

  def pseudolegal_moves_by(pos)
    @board.piece_move_generator.call(self,pos)
  end

  def pseudolegal_moves
    @board.move_generator(playing_side).call(self)
  end

  def leaves_king_safe?(move)
    next_board = @board.clone
    next_board.move_piece(move)

    !next_board.attack_map(opposing_side)[next_board.king_position(playing_side)]
  end

  def may_castle?(castle_side, player_side)
    king_position = board.king_position(player_side)
    the_king = board[king_position].piece
    return false if the_king.has_moved

    opponent = the_king.opponent

    case castle_side
    when :king_side
      rook_position = king_position + 3
      castling_range = [king_position + 1, king_position + 2]
      kings_path = [king_position, 
                    king_position + 1,
                    king_position + 2]
    when :queen_side
      rook_position = king_position - 4
      castling_range = [king_position - 1, 
                        king_position - 2,
                        king_position - 3]
      kings_path = [king_position, 
                    king_position - 1,
                    king_position - 2]
    end

    the_rook = board[rook_position].piece

    the_rook.is_a?(Rook) &&
    !the_rook.has_moved &&
    castling_range.all? { |pos| !board[pos].occupied? } &&
    kings_path.all? { |pos| !board.attack_map(opponent)[pos] }
  end
end
