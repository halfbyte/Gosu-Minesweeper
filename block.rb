require 'constants'

module Minesweeper
  # One block in the grid
  class Block
    include Constants

    attr_accessor :number

    @image = nil
    @game  = nil
    @font  = nil

    class << self
      attr_accessor :image, :game, :font
    end

    def initialize( point, bomb = false, number = 0 )
      @point, @bomb, @number = point, bomb, number

      @hidden = true
      @marked = false
    end

    def hidden?
      @hidden
    end

    def show
      @hidden = false
    end

    def marked?
      @marked
    end

    def mark
      @marked = true
    end

    def bomb?
      @bomb
    end

    def add_bomb
      @bomb = true
    end

    def draw
      if hidden?
        self.class.image.draw( @point.x, @point.y, 1 )
      elsif @number > 0
        self.class.game.draw_rectangle( @point, TILE_SIZE, 1, Gosu::Color::WHITE )
        self.class.font.draw( @number.to_s, @point.x + 8, @point.y + 2, 2,
                              1, 1, NUMBERS[@number] )
      else
        self.class.game.draw_rectangle( @point, TILE_SIZE, 1, SILVER )
      end
    end
  end
end
