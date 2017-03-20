require 'chess/tile'
require 'chess/position'

class Board < Array
  DEFAULT_0X88_SIZE = 128

  def initialize
    super(DEFAULT_0X88_SIZE)
    
    self.each_index do |pos|
      self[pos] = Tile.new if Position::valid?(pos)
    end

    populate()
  end

  def populate
    self[0x10..0x17].each { |tile| tile.piece = Pawn.new(:white) }
    self[0x60..0x67].each { |tile| tile.piece = Pawn.new(:black) }

    self[0x00].piece = Rook.new(:white)
    self[0x01].piece = Knight.new(:white)
    self[0x02].piece = Bishop.new(:white)
    self[0x03].piece = Queen.new(:white)
    self[0x04].piece = King.new(:white)
    self[0x05].piece = Bishop.new(:white)
    self[0x06].piece = Knight.new(:white)
    self[0x07].piece = Rook.new(:white)

    self[0x70].piece = Rook.new(:black)
    self[0x71].piece = Knight.new(:black)
    self[0x72].piece = Bishop.new(:black)
    self[0x73].piece = Queen.new(:black)
    self[0x74].piece = King.new(:black)
    self[0x75].piece = Bishop.new(:black)
    self[0x76].piece = Knight.new(:black)
    self[0x77].piece = Rook.new(:black)
  end

  def clone
    clone_board = Board.new
    self.each_index { |pos|
      clone_board[pos].piece = self[pos].piece if Position::valid?(pos)
    }
    return clone_board
  end

  def move_piece(move)
    from = move[0]
    to = move[1]

    self[to].piece = self[from].piece
    self[from].piece = nil

    self[to].piece.move
  end

  def king_position(side)
    self.find_index.with_index do |tile, pos| 
       if Position::valid?(pos) && tile.occupied?
         tile.piece.type == :king && tile.piece.side == side
       else
         false
       end
    end
  end

  def piece_positions(side)
    self.each.with_index.reduce([]) do |acc, (tile, pos)|
      if Position::valid?(pos) && tile.occupied? && tile.piece.side == side
        acc << pos
      else
        acc
      end
    end
  end

  def attack_map(side)
    attacked_positions(side).reduce(Array.new(128)) do |acc, pos|
      acc[pos] = true
      acc
    end
  end

  def attacked_positions(side)
    piece_positions(side).reduce([]) do |acc, pos|
      (acc + 
       attacked_positions_by(pos, &(self[pos].piece.class::attack_pattern))
      ).uniq
    end
  end

  def attacked_positions_by(pos, &attack_pattern)
    yield(self, pos)
  end

  def piece_move_generator
    Proc.new do |game, pos|
      self[pos].piece.class.move_pattern.call(game, pos)
    end
  end

  def move_generator(side)
    Proc.new do |game|
      piece_positions(side).reduce([]) do |acc, pos|
        acc + piece_move_generator.call(game,pos)
      end
    end
  end
end
