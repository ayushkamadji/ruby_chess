require 'chess/piece'

class Pawn < Piece
  def initialize(side)
    super(:pawn, side)
  end

  def self.attack_pattern
    Proc.new do |board, pos|
      advance = board[pos].piece.side == :white ? 
                Position::RANK_WIDTH : 
                -Position::RANK_WIDTH

      [(pos + advance + 1), (pos + advance - 1)].reduce([]) do |acc, pos|
        Position::valid?(pos)? acc << pos  : acc
      end
    end
  end
end
