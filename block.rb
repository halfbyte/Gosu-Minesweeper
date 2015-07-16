require 'constants'

module Minesweeper
  # One block in the grid
  class Block
    include Constants

    attr_accessor :number

    @game   = nil
    @font   = nil

    class << self
      attr_accessor :game, :font
    end

    def self.setup_graphics(game)
      @game = game
      @font = game.font[:block]
    end

    def self.image(name)
      @game.image[name]
    end

    def initialize(point)
      @point  = point

      @bomb   = false
      @number = 0
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

    def show_if_bad
      show if marked? != bomb?
    end

    def toggle_mark
      @marked = !@marked if closed?
    end

    def add_bomb
      @bomb = true
    end

    def draw
      return draw_closed if closed?

      game.draw_rectangle(@point, TILE_SIZE, 1, Gosu::Color::WHITE)

      px = @point.x
      py = @point.y
      return image(:bomb).draw(px, py, 1) if bomb?    # Oops

      # Incorrectly Marked?
      return image(:not_bomb).draw(px, py, 1) if marked?

      draw_open
    end

    def draw_closed
      px = @point.x
      py = @point.y

      image(:tile).draw(px, py, 1)
      image(:flag).draw(px, py, 2) if marked?
    end

    def draw_open
      font.draw(@number.to_s, @point.x + 8, @point.y + 2, 2, 1, 1,
                NUMBERS[@number]) if number > 0
    end

    private

    def game
      self.class.game
    end

    def image(name)
      self.class.image(name)
    end

    def font
      self.class.font
    end
  end
end
