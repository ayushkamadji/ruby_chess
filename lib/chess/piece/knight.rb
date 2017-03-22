require 'chess/piece'

class Knight < Piece
  OFFSETS = [16 * 2 + 1, 
             16 * 2 - 1,
             16  + 2,
             16 - 2,
             -16 + 2,
             -16 - 2,
             -16 * 2 + 1,
             -16 * 2 - 1] 


  def initialize(side)
    super(:knight, side)
  end

  def self.attack_pattern
    Proc.new do |board, pos|
      OFFSETS.reduce([]) do |acc, offset|
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
      board = game.board
      opponent = board[pos].piece.opponent

      OFFSETS.reduce([]) do |acc, offset|
        if (Position::valid?(pos + offset) &&
            (!board[pos + offset].occupied? ||
             board[pos + offset].piece.side == opponent))
          acc << [pos, pos + offset]
        else
          acc
        end
      end
    end
  end
end
