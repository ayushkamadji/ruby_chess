$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'chess/game'

def display_board(board)
  clear
  board.each_slice(16).with_index.reverse_each do |row, index|
    print "\n#{index+1}|"
    row.each_with_index do |tile, pos|
      print_tile(tile) if Position::valid?(pos)
    end
  end
  print "\n"
  print "  -----------------------\n"
  print "   a  b  c  d  e  f  g  h\n"
end

def clear
  print "\e[2J\e[1;1H"
end


def print_tile(tile)
  if tile.piece != nil
    case tile.piece.type
    when :pawn then chara = 'p'
    when :knight then chara = 'n'
    when :king then chara = 'k'
    when :queen then chara = 'q'
    when :bishop then chara = 'b'
    when :rook then chara = 'r'
    end
  else
    chara = '-'
  end

  if tile.piece != nil
    chara = (chara.ord - 32).chr if tile.piece.side == :white
  end

  print " #{chara} "
end

def disp_atk_map(board, side)
   board.attack_map(side).each_slice(16).reverse_each do |row|
     print "\n"
     row[0..7].each do |val|
       chara = val ? 't' : '.'
       print " #{chara}"
     end
   end
   print "\n"
 end

def start_game
  game = Game.new
  until game.over?
    move = [nil, nil]
    until game.legal_moves.include?(move)
      display_board(game.board)
      disp_atk_map(game.board, game.opposing_side)
      print "Check!\n" if game.playing_side_in_check?
      print "#{game.playing_side} to move\n"
      move = parse_move(gets.strip)
      if !game.legal_moves.include?(move)
        print "Try again"
        gets
      end
    end

    if Move::needs_promotion?(move, game.board)
      print "promote to?\n"
      promotion_piece_type = parse_type(gets.strip)
    end

    game.play(move)
  end

  display_board(game.board)
  if game.checkmate?
    print "Checkmate\n"
    print "#{game.opposing_side} wins"
  end
  if game.stalemate?
    print "Stalemate\n"
  end
  gets
end

def parse_move(string)
  tile_names = string.split(' ')
  tile_names.map do |name|
   Position::name_to_pos(name)
  end
end

def parse_type(string)
  case string
  when "knight" then return :knight
  when "bishop" then return :bishop
  when "rook" then return :rook
  when "queen" then return :queen
  end
end
