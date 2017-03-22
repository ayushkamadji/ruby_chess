require 'chess/piece'

class King < Piece
  OFFSETS = [16 + 1, 
             16 - 1, 
             -16 + 1,
             -16 - 1,
             16,
             1,
             -16,
             -1]
  CASTLE_KING_SIDE_OFFSET = 2
  CASTLE_QUEEN_SIDE_OFFSET = -2

  def initialize(side)
    super(:king, side)
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
      player_side = board[pos].piece.side
      opponent = board[pos].piece.opponent
      
      moves = OFFSETS.reduce([]) do |acc, offset|
                if (Position::valid?(pos + offset) &&
                    (!board[pos + offset].occupied? ||
                     board[pos + offset].piece.side == opponent))
                  acc << [pos, pos + offset]
                else
                  acc
                end
              end

      castles = []
      if game.may_castle?(:king_side, player_side)
        castles << [pos, pos + CASTLE_KING_SIDE_OFFSET]
      end
      if game.may_castle?(:queen_side, player_side)
        castles << [pos, pos + CASTLE_QUEEN_SIDE_OFFSET]
      end

      moves + castles
    end
  end
end
