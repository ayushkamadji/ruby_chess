class Position
  RANK_WIDTH = 16
  RANKS = 8

  def self.valid?(pos)
    (pos < RANK_WIDTH * RANKS) && (pos & 0x88) == 0
  end

  def self.rank(pos)
    (pos / RANK_WIDTH) * RANK_WIDTH
  end

  def self.file(pos)
    pos - rank(pos)
  end

  def self.name_to_pos(name)
    name_array = name.split('')
    (name[0].ord - 'a'.ord) + ((name[1].to_i - 1) * RANK_WIDTH)
  end
end
