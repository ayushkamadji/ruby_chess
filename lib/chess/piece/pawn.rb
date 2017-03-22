require 'chess/piece'

class Pawn < Piece
  def initialize(side)
    super(:pawn, side)
  end

  def self.attack_pattern
    Proc.new do |board, pos|
      side = board[pos].piece.side
      advance_offset = board[pos].piece.side == :white ? 
                Position::RANK_WIDTH : 
                -Position::RANK_WIDTH

      offsets = [advance_offset + 1, advance_offset - 1]

      capture_offsets(side).reduce([]) do |acc, offset|
        if Position::valid?(pos + offset)
          acc << pos + offset
        else 
          acc
        end
      end
    end
  end

  def self.move_pattern
    Proc.new do |game, pos|
      side = game.board[pos].piece.side
      opponent = game.board[pos].piece.opponent

      moves = []
      moves << [pos, pos + advance_offset(side)] if Position::valid?(pos + advance_offset(side)) && 
                                                    !game.board[pos + advance_offset(side)].occupied?
      moves << [pos, pos + double_advance_offset(side)] if Position::valid?(pos + double_advance_offset(side)) &&
                                                           !game.board[pos + double_advance_offset(side)].occupied? &&
                                                           !game.board[pos].piece.has_moved

      captures = capture_offsets(side).reduce([]) do |acc, offset|
                   target = pos + offset
                   target_tile = game.board[target]
                   if (Position::valid?(target) && 
                       (target == game.ep_position ||
                        (target_tile.occupied? &&
                        target_tile.piece.side == opponent))
                      )
                     acc << [pos, pos + offset]
                   else
                     acc
                   end
                 end

      moves + captures
    end
  end

  def self.advance_offset(side)
    side == :white ? 16 : -16
  end

  def self.double_advance_offset(side)
    2 * advance_offset(side)
  end

  def self.capture_offsets(side)
    [advance_offset(side) + 1, advance_offset(side) - 1]
  end

  def self.ep_capture_position_offset(side)
    -1 * advance_offset(side)
  end
end
