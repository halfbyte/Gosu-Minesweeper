#!/usr/bin/env ruby -I.

require 'constants'
require 'resources'
require 'grid'
require 'gameover'
require 'renderer'

module Minesweeper
  # Minesweeper game
  class Game < Gosu::Window
    include Constants

    attr_reader :image, :font, :grid, :start_time

    def initialize(debug = false)
      super(WIDTH, HEIGHT, false)
      self.caption = 'Gosu Minesweeper'

      load_resources

      @debug = debug
      @renderer = Renderer.new(self)

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
        @overlay ||= GameOver.new(self)
      elsif @position
        update_position
      end
    end

    def draw
      @renderer.draw(@overlay)
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
      @overlay = nil
      @grid = Grid.new(16, 16)
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
  end

  # Hold the mouse position and the operation to perform
  class Position
    include GosuEnhanced

    attr_reader :point, :op

    # This reeks of :reek:UncommunicativeParameterName
    def initialize(x, y, op)
      @point = Point.new(x, y)
      @op = op
    end
  end
end

Minesweeper::Game.new(:debug).show
