require 'chess/piece/pawn'
require 'chess/piece/knight'
require 'chess/piece/rook'
require 'chess/piece/bishop'
require 'chess/piece/queen'
require 'chess/piece/king'

class Tile
  attr_accessor :piece

  def initialize(piece=nil)
    @piece = piece
  end

  def occupied?
    @piece != nil
  end
end
