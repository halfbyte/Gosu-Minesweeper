module Minesweeper
  # Load necessary graphic resources
  class ResourceLoader
    def self.fonts
      default = Gosu.default_font_name

      {
        block:    Gosu::Font.new(20, name: 'Arial Bold'),
        display:  Gosu::Font.new(60, name: default),
        header:   Gosu::Font.new(36, name: default),
        title:    Gosu::Font.new(24, name: default),
        info:     Gosu::Font.new(16, name: default)
      }
    end

    def self.images
      {
        background: Gosu::Image.new('media/Background.png'),
        tile:       Gosu::Image.new('media/Tile.png'),
        bomb:       Gosu::Image.new('media/Bomb.png'),
        flag:       Gosu::Image.new('media/Flag.png'),
        not_bomb:   Gosu::Image.new('media/NotBomb.png'),
        digits:     Gosu::Image.load_tiles('media/Digits.png', 34, 60,
                                           tileable: true)
      }
    end
  end
end
