#!/usr/bin/env ruby -I.

require 'constants'
require 'resources'
require 'grid'

module Minesweeper
  # Minesweeper game
  class Game < Gosu::Window
    include Constants

    attr_reader :image, :font

    def initialize
      super( WIDTH, HEIGHT, false, 50 )
      self.caption = 'Gosu Minesweeper'

      load_resources
      reset_game
    end

    def needs_cursor?
      true
    end

    def update
      update_position if @position
    end

    def draw
      draw_background
      draw_grid
    end

    def button_down( code )
      close if code == Gosu::KbEscape   # DEBUG
      reset_game if code == Gosu::KbR
      @grid.open_all if code == Gosu::KbO

      @start_time ||= Time.now

      if button_down?( Gosu::MsLeft ) && button_down?( Gosu::MsRight )
        return @position = Position.new( mouse_x, mouse_y, :auto_open)
      end

      @position = Position.new( mouse_x, mouse_y, :mark ) if code == Gosu::MsRight
    end

    # Left Mouse Button is detected on release to avoid it being triggered
    # accidentally on a bombed square.
    def button_up( code )
      return unless code == Gosu::MsLeft && !button_down?( Gosu::MsRight )

      @position = Position.new( mouse_x, mouse_y, :open )
    end

    private

    def reset_game
      @grid = Grid.new
      @start_time = nil
    end

    def load_resources
      loader = ResourceLoader.new( self )

      @image = loader.images
      @font  = loader.fonts

      Block.setup_graphics( self )
    end

    def update_position
      @grid.send( @position.op, @position.point )

      @position = nil
    end

    def draw_background
      @image[:background].draw( 0, 0, 0 )
    end

    def draw_grid
      @grid.draw
    end
  end

  # Hold the mouse position and the operation to perform
  class Position
    include GosuEnhanced

    attr_reader :point, :op

    def initialize( x, y, op )
      @point = Point.new( x, y )
      @op = op
    end
  end
end

Minesweeper::Game.new.show
