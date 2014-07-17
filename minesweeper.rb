#!/usr/bin/env ruby -I.

require 'constants'
require 'resources'
require 'grid'

module Minesweeper
  # Minesweeper game
  class Game < Gosu::Window
    include Constants

    attr_reader :images

    def initialize
      super( WIDTH, HEIGHT, false, 50 )
      self.caption = 'Gosu Minesweeper'

      load_resources

      @grid = Grid.new
    end

    def needs_cursor?
      true
    end

    def update
    end

    def draw
      draw_background
      draw_grid
    end

    private

    def load_resources
      loader = ResourceLoader.new( self )

      @images = loader.images
      @fonts  = loader.fonts

      Block.setup_graphics( self, @images, @fonts )
    end

    def draw_background
      point = Point.new( 0, 0 )
      size  = Size.new( WIDTH, HEIGHT )
      draw_rectangle( point, size, 0, SILVER )

      point.move_to!( GRID_ORIGIN.x - 1, GRID_ORIGIN.y - 1 )
      draw_rectangle( point, GRID_SIZE.inflate( 2, 2 ), 0, Gosu::Color::BLACK )
    end

    def draw_grid
      @grid.draw
    end
  end
end

Minesweeper::Game.new.show
