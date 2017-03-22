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

  def self.generate_new(type, side)
    case type
    when :king then return King.new(side)
    when :queen then return Queen.new(side)
    when :rook then return Rook.new(side)
    when :bishop then return Bishop.new(side)
    when :knight then return Knight.new(side)
    when :pawn then return Pawn.new(side)
    end
  end
end
