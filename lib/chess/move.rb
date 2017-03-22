class Move
  def self.is_pawn_double_advance?(move, board)
    from = move[0]
    to = move[1]
    board[to].piece.is_a?(Pawn) && (to - from).abs == 2 * Position::RANK_WIDTH
  end

  def self.needs_promotion?(move, board)
    from = move[0]
    to = move[1]

    case board[from].piece.side
    when :white then end_rank = 0x70
    when :black then end_rank = 0x00
    end

    board[from].piece.is_a?(Pawn) && Position::rank(to) == end_rank
  end

  def self.is_castling?(move, board)
    from = move[0]
    to = move[1]

    board[to].piece.is_a?(King) && (to - from).abs == 2
  end

  def self.is_ep_capture?(move, game)
    to = move[1]

    game.board[to].piece.is_a?(Pawn) && to == game.ep_position
  end
end
