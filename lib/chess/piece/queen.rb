require 'chess/piece'

class Queen < Piece
  OFFSETS = [16 + 1, 
             16 - 1, 
             -16 + 1,
             -16 - 1,
             16,
             1,
             -16,
             -1]

  def initialize(side)
    super(:queen, side)
  end

  def self.attack_pattern
    Proc.new do |board, pos|
      OFFSETS.reduce([]) do |acc, offset| 
         rec_offset = offset

         while (Position::valid?(pos + rec_offset))
           acc << pos + rec_offset
           break if board[pos + rec_offset].occupied?
           rec_offset += offset
         end

         acc
      end   
    end
  end

  def self.move_pattern
    Proc.new do |game, pos|
      board = game.board
      opponent = board[pos].piece.opponent

      OFFSETS.reduce([]) do |acc, offset| 
         rec_offset = offset

         while (Position::valid?(pos + rec_offset))
           if (!board[pos + rec_offset].occupied? ||
               board[pos + rec_offset].piece.side == opponent)
             acc << [pos, pos + rec_offset]
           end

           break if board[pos + rec_offset].occupied?
           rec_offset += offset
         end

         acc
      end   
    end
  end
end
