module Minesweeper
  # Load necessary graphic resources
  class ResourceLoader
    def initialize(game)
      @game = game
    end

    def fonts
      {
        block:    Gosu::Font.new(@game, 'Arial Bold', 20),
        display:  Gosu::Font.new(@game, Gosu.default_font_name, 60)
      }
    end

    def images
      {
        background: Gosu::Image.new(@game, 'media/Background.png', true),
        tile:       Gosu::Image.new(@game, 'media/Tile.png', true),
        bomb:       Gosu::Image.new(@game, 'media/Bomb.png', true),
        flag:       Gosu::Image.new(@game, 'media/Flag.png', true),
        not_bomb:   Gosu::Image.new(@game, 'media/NotBomb.png', true)
      }
    end
  end
end
