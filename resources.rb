module Minesweeper
  # Load necessary graphic resources
  class ResourceLoader
    def initialize( game )
      @game = game
    end

    def fonts
      {
        block:  Gosu::Font.new( @game, 'Arial', 20 )
      }
    end

    def images
      {
        tile: Gosu::Image.new( @game, 'media/Tile.png', true ),
        bomb: Gosu::Image.new( @game, 'media/Bomb.png', true ),
        flag: Gosu::Image.new( @game, 'media/Flag.png', true )
      }
    end
  end
end
