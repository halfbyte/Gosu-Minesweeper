require 'block'

module Minesweeper
  # Mined grid
  class Grid
    include Constants

    def initialize( width = GRID_WIDTH, height = GRID_HEIGHT )
      @width, @height = width, height

      @origin = GRID_ORIGIN.offset( (GRID_WIDTH - width) * TILE_WIDTH / 2,
                                    (GRID_HEIGHT - height) * TILE_HEIGHT / 2 )

      @grid = empty_grid
    end

    def draw
      each { |block| block.draw }
    end

    def each
      @grid.each { |block| yield block }
    end

    private

    def empty_grid
      grid = []

      (0...@height).each do |row|
        (0...@width).each do |col|
          block = Block.new( @origin.offset( col * TILE_WIDTH, row * TILE_HEIGHT ), false, rand( 0..8 ) )
          block.show if rand( 0..1 ) == 1

          grid << block
        end
      end

      grid
    end
  end
end
