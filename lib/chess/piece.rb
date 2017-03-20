require 'chess/move'

class Piece
  attr_reader :type, :side, :has_moved

  def initialize(type=:none, side=:none)
    @type = type
    @side = side
    @has_moved = false
  end

  def opponent
    @side == :white ? :black : :white
  end

  def move
    @has_moved = true
  end
end
