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

    def initialize(point, bomb = false, number = 0)
      @point  = point
      @bomb   = bomb
      @number = number

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

      return image(:bomb).draw(@point.x, @point.y, 1) if bomb?    # Oops

      # Incorrectly Marked?
      return image(:not_bomb).draw(@point.x, @point.y, 1) if marked?

      font.draw(@number.to_s, @point.x + 8, @point.y + 2, 2, 1, 1,
                NUMBERS[@number]) if number > 0
    end

    def draw_closed
      image(:tile).draw(@point.x, @point.y, 1)
      image(:flag).draw(@point.x, @point.y, 2) if marked?
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
