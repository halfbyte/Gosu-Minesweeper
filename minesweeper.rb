#!/usr/bin/env ruby -I.

require 'gosu_enhanced'

require 'constants'

module Minesweeper
  # Minesweeper game
  class Game < Gosu::Window
    include Constants

    attr_reader :images

    def initialize
      super( WIDTH, HEIGHT, false, 50 )
      self.caption = 'Gosu Minesweeper'

      @images = { tile: Gosu::Image.new( self, 'media/Tile.png', true ) }
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

    def draw_background
      point = Point.new( 0, 0 )
      size  = Size.new( WIDTH, HEIGHT )
      draw_rectangle( point, size, 0, SILVER )

      point.move_to!( GRID_ORIGIN.x - 1, GRID_ORIGIN.y - 1 )
      draw_rectangle( point, GRID_SIZE.inflate( 2, 2 ), 0, Gosu::Color::BLACK )
    end

    def draw_grid
      (0...16).each do |row|
        (0...30).each do |col|
          images[:tile].draw(
            GRID_ORIGIN.x + TILE_WIDTH * col, GRID_ORIGIN.y + TILE_HEIGHT * row, 1 )
        end
      end
    end
  end
end

Minesweeper::Game.new.show
