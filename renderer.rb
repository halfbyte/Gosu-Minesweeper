module Minesweeper
  # Renderer for the game
  class Renderer
    include Constants

    COLON = 10

    def initialize(game)
      @game        = game
      @bomb_led    = LED.new(game, 495, 9)
      @elapsed_led = LED.new(game, 210, 9)
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

      @bomb_led.draw(digits)
    end

    def draw_elapsed
      elapsed = (Time.now - @game.start_time).to_i
      secs    = elapsed % 60
      digits  = [elapsed / 60, COLON, secs / 10, secs % 10]

      @elapsed_led.draw(digits)
    end

    def draw_grid
      @game.grid.draw
    end
  end
end

# Draw a set of digits to look like a 7-segment LED display
class LED
  def initialize(game, left, top)
    @images = game.image[:digits]
    @left   = left
    @top    = top
  end

  def draw(digits)
    col = @left

    digits.each do |digit|
      @images[digit].draw(col, @top, 1)
      col += @images[0].width
    end
  end
end
