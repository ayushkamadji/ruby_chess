class Position
  RANK_WIDTH = 16
  RANKS = 8

  def self.valid?(pos)
    (pos < RANK_WIDTH * RANKS) && (pos & 0x88) == 0
  end

end
