#!/usr/bin/env ruby -I.

require 'constants'
require 'resources'
require 'grid'

module Minesweeper
  # Minesweeper game
  class Game < Gosu::Window
    include Constants

    attr_reader :image, :font

    def initialize(debug = false)
      super(WIDTH, HEIGHT, false)
      self.caption = 'Gosu Minesweeper'

      @debug = debug

      load_resources
      reset_game
    end

    def needs_cursor?
      true
    end

    def failed?
      @grid && @grid.failed
    end

    def completed?
      @grid && @grid.complete
    end

    def update
      if failed? || completed?
        puts failed? ? "Oops!" : "Woohoo!"
      else
        update_position if @position
      end
    end

    def draw
      draw_background
      draw_header
      draw_grid
    end

    def button_down(code)
      return @position = Position.new(mouse_x, mouse_y, :auto_open) \
        if button_down?(Gosu::MsLeft) && button_down?(Gosu::MsRight)

      case code
      when Gosu::KbEscape then close if @debug
      when Gosu::KbR      then reset_game
      when Gosu::MsRight  then @position = Position.new(mouse_x, mouse_y, :mark)

      when Gosu::MsMiddle
        @position = Position.new(mouse_x, mouse_y, :safe_open) if @debug
      end
    end

    # Left Mouse Button is detected on release to avoid it being triggered
    # accidentally on a bombed square.
    def button_up(code)
      @start_time ||= Time.now

      return unless code == Gosu::MsLeft && !button_down?(Gosu::MsRight)

      @position = Position.new(mouse_x, mouse_y, :open)
    end

    private

    def reset_game
      @grid = Grid.new(9, 9)
      @start_time = nil
    end

    def load_resources
      @image = ResourceLoader.images
      @font  = ResourceLoader.fonts

      Block.setup_graphics(self)
    end

    def update_position
      @grid.send(@position.op, @position.point)

      @position = nil
    end

    def draw_background
      @image[:background].draw(0, 0, 0)
    end

    def draw_header
      @font[:display].draw(@grid.bombs_left.to_s, 500, 10, 1, 1, 1, DISPLAY)

      return unless @start_time

      elapsed = (Time.now - @start_time).to_i
      time    = format('%01d:%02d', elapsed / 60, elapsed % 60)
      @font[:display].draw(time, 250, 10, 1, 1, 1, DISPLAY)
    end

    def draw_grid
      @grid.draw
    end
  end

  # Hold the mouse position and the operation to perform
  class Position
    include GosuEnhanced

    attr_reader :point, :op

    def initialize(x, y, op)
      @point = Point.new(x, y)
      @op = op
    end
  end
end

Minesweeper::Game.new(:debug).show
