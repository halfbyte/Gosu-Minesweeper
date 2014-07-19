require 'constants'

module Minesweeper
  # One block in the grid
  class Block
    include Constants

    attr_accessor :number

    @tile   = nil
    @bomb   = nil
    @flag   = nil
    @game   = nil
    @font   = nil

    class << self
      attr_accessor :tile, :bomb, :flag, :game, :font
    end

    def self.setup_graphics( game, images, fonts )
      @game = game
      @tile = images[:tile]
      @bomb = images[:bomb]
      @flag = images[:flag]
      @font = fonts[:block]
    end

    def initialize( point, bomb = false, number = 0 )
      @point, @bomb, @number = point, bomb, number

      @closed = true
      @marked = false
    end

    def closed?
      @closed
    end

    def marked?
      @marked
    end

    def bomb?
      @bomb
    end

    def empty?
      !bomb? && @number == 0
    end

    # Show returns whether a bomb has been uncovered
    def show
      @closed = false
      bomb?
    end

    def toggle_mark
      @marked = !@marked if closed?
    end

    def add_bomb
      @bomb = true
    end

    def draw
      return draw_closed if closed?

      game.draw_rectangle( @point, TILE_SIZE, 1, Gosu::Color::WHITE )

      return self.class.bomb.draw( @point.x, @point.y, 1 ) if bomb?    # Oops

      # Incorrectly Marked?
      game.draw_rectangle( @point, TILE_SIZE, 1, Gosu::Color::RED ) if marked?

      self.class.font.draw( @number.to_s, @point.x + 8, @point.y + 2, 2,
                              1, 1, NUMBERS[@number] ) if number > 0
    end

    def draw_closed
      self.class.tile.draw( @point.x, @point.y, 1 )
      self.class.flag.draw( @point.x, @point.y, 2 ) if marked?
    end

    private

    def game
      self.class.game
    end
  end
end
