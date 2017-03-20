describe Game do
  let(:game) { Game.new }
  
  describe "#pseudolegal_moves_by" do
    context "pawn moves" do
      context "initial board at b1 pawn" do
        it "returns advance and double advance by b1" do
          expect(game.pseudolegal_moves_by(0x11)).to match_array(
            [[0x11, 0x21],
             [0x11, 0x31]]
          )
        end
      end
    end
  end
end
