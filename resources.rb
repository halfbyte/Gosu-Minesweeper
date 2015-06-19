module Minesweeper
  # Load necessary graphic resources
  class ResourceLoader
    def self.fonts
      {
        block:    Gosu::Font.new(20, name: 'Arial Bold'),
        display:  Gosu::Font.new(60, name: Gosu.default_font_name)
      }
    end

    def self.images
      {
        background: Gosu::Image.new('media/Background.png'),
        tile:       Gosu::Image.new('media/Tile.png'),
        bomb:       Gosu::Image.new('media/Bomb.png'),
        flag:       Gosu::Image.new('media/Flag.png'),
        not_bomb:   Gosu::Image.new('media/NotBomb.png'),
        digits:     Gosu::Image.load_tiles('media/Digits.png', 34, 60, tileable: true)
      }
    end
  end
end
