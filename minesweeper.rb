#!/usr/bin/env ruby -I.

require 'gosu_enhanced'

require 'constants'

module Minesweeper
  class Game < Gosu::Window
    include Constants

    attr_reader :images

    def initialize
      super( WIDTH, HEIGHT, false, 50 )
      self.caption = "Gosu Minesweeper"

      @images = { tile: Gosu::Image.new( self, 'media/Tile.png', true ) }
    end

    def needs_cursor?
      true
    end

    def update

    end

    def draw
      point = Point.new( 0, 0 )
      size  = Size.new( WIDTH, HEIGHT )
      draw_rectangle( point, size, 0, SILVER )

      point.move_by!( 5, 80 + MARGIN )
      size.deflate!( 10,  80 + MARGIN * 2 )
      draw_rectangle( point, size, 0, Gosu::Color::BLACK )

      point.move_by!( 1, 1 )

      (0...16).each do |row|
        (0...30).each do |col|
          images[:tile].draw( point.x + TILE_WIDTH * col, point.y + TILE_HEIGHT * row, 1 )
        end
      end
    end
  end
end

Minesweeper::Game.new.show
