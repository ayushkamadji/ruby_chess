class Piece
  attr_reader :type, :side

  def initialize(type=:none, side=:none)
    @type = type
    @side = side
  end
end
