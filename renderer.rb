module Minesweeper
  # Renderer for the game
  class Renderer
    include Constants

    COLON = 10

    def initialize(game)
      @game = game
    end

    def draw
      draw_background
      draw_bomb_count
      draw_elapsed if @game.start_time
      draw_grid
    end

    private

    def draw_background
      @game.image[:background].draw(0, 0, 0)
    end

    def draw_bomb_count
      bombs = @game.grid.bombs_left
      digits = [bombs / 10, bombs % 10]

      display_led(digits, 495, 9)
    end

    def draw_elapsed
      elapsed = (Time.now - @game.start_time).to_i
      time    = format('%01d:%02d', elapsed / 60, elapsed % 60)
      digits = [elapsed / 60, COLON, elapsed % 60 / 10, elapsed % 60 % 10]

      display_led( digits, 210, 9)
    end

    def draw_grid
      @game.grid.draw
    end

    def display_led(digits, x, y)
      digits.each do |n|
        @game.image[:digits][n].draw(x, y, 1)
        x += @game.image[:digits][0].width
      end
    end
  end
end
