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
end
