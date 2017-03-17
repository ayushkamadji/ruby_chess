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
    chara = '.'
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
