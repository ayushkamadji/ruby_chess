require 'chess/piece'

class Rook < Piece
  OFFSETS = [16, 1, -16, -1]

  def initialize(side)
    super(:rook, side)
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

  def self.move_pattern #STUB
    Proc.new { [] }
  end
end
