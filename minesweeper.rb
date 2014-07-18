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
      update_position if @position
    end

    def draw
      draw_background
      draw_grid
    end

    def button_down( code )
      close if code == Gosu::KbEscape

      if button_down?( Gosu::MsLeft ) && button_down?( Gosu::MsRight )
        return puts 'Both Both'
      end

      if button_down?( Gosu::MsLeft )   # On for a chord
        return puts 'Both RL' if code == Gosu::MsRight
      end

      if button_down?( Gosu::MsRight )
        return puts 'Both LR ' if code == Gosu::MsLeft
      end

      print 'Right Only :mark, ' if code == Gosu::MsRight
      @position = [mouse_x, mouse_y, :mark] if code == Gosu::MsRight
    end

    def button_up( code )
      print 'Left Only :open, ' if code == Gosu::MsLeft && !button_down?( Gosu::MsRight )
      @position = [mouse_x, mouse_y, :open] if code == Gosu::MsLeft && !button_down?( Gosu::MsRight )
    end

    private

    def load_resources
      loader = ResourceLoader.new( self )

      @images = loader.images
      @fonts  = loader.fonts

      Block.setup_graphics( self, @images, @fonts )
    end

    def update_position
      block = @grid.block_from_position @position
      op    = @position[2]

      @position = nil

      return unless block

      case op
      when :mark  then block.toggle_mark
      when :open  then block.show
      end
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
