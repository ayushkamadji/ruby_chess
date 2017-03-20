require 'chess/board'

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

  def playing_side_in_check?
    board.attack_map(opposing_side)[board.king_position(playing_side)]
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

  def end_turn
    @playing_side = opposing_side
  end
end
