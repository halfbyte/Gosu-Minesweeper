module Minesweeper
  # Renderer for the game
  class Renderer
    include Constants

    COLON = 10

    def initialize(game)
      @game = game
    end

    def draw(overlay)
      draw_background
      draw_bomb_count
      draw_elapsed if @game.start_time && !overlay
      draw_grid
      overlay.draw if overlay
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
      secs    = elapsed % 60
      digits  = [elapsed / 60, COLON, secs / 10, secs % 10]

      display_led(digits, 210, 9)
    end

    def display_led(digits, x, y)
      dimage = @game.image[:digits]

      digits.each do |n|
        dimage[n].draw(x, y, 1)
        x += dimage[0].width
      end
    end

    def draw_grid
      @game.grid.draw
    end
  end
end
