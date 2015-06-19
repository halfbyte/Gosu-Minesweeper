module Minesweeper
  # Show a completed window
  class GameOver
    include Constants

    def initialize(game)
      @game   = game
      @header = game.font[:header]
      @title  = game.font[:title]
      @ins    = game.font[:info]

      @size   = Size.new(WIDTH * 2 / 3, HEIGHT / 2)
      @pos    = Point.new(WIDTH / 6, HEIGHT / 3)
    end

    def draw
      @game.draw_rectangle(@pos.offset(-10, -10), @size.inflate(20, 20), 5,
                           SHADOW)

      @game.draw_rectangle(@pos, @size, 5, OVERLAY_BG)

      draw_header
      draw_result
      draw_instructions
    end

    private

    def draw_header
      complete  = "You're through the minefield"
      hsize     = @header.measure(complete)
      hpos      = @pos.offset((@size.width - hsize.width) / 2, hsize.height)

      @header.draw(complete, hpos.x, hpos.y, 6, 1, 1, BLUE1)
    end

    def draw_result
      if @game.failed?
        complete = 'Unfortunately, without any lower legs'
        colour   = RED3
      else
        complete = 'You found all the mines'
        colour   = BLUE1
      end

      tsize     = @title.measure(complete)
      hpos      = @pos.offset((@size.width - tsize.width) / 2, tsize.height * 5)

      @title.draw(complete, hpos.x, hpos.y, 6, 1, 1, colour)
    end

    def draw_instructions
      text  = 'Press Escape to Exit'
      tsize = @ins.measure(text)
      hpos  = @pos.offset((@size.width - tsize.width) / 2,
                          @size.height - tsize.height * 4)

      @ins.draw(text, hpos.x, hpos.y, 6, 1, 1, CYAN6)

      text  = 'Press R to Restart'
      tsize = @ins.measure(text)
      hpos  = @pos.offset((@size.width - tsize.width) / 2,
                          @size.height - tsize.height * 5 / 2)

      @ins.draw(text, hpos.x, hpos.y, 6, 1, 1, CYAN6)
    end
  end
end
