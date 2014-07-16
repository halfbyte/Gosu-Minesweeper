#!/usr/bin/env ruby -I.

require 'constants'
require 'grid'

module Minesweeper
  # Minesweeper game
  class Game < Gosu::Window
    include Constants

    attr_reader :images

    def initialize
      super( WIDTH, HEIGHT, false, 50 )
      self.caption = 'Gosu Minesweeper'

      set_images
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

    def set_images
      @images = { tile: Gosu::Image.new( self, 'media/Tile.png', true ) }

      Block.image = @images[:tile]
      Block.game  = self
      Block.font  = Gosu::Font.new( self, Gosu.default_font_name, 20 )
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
