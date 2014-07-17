require 'block'

module Minesweeper
  # Mined grid
  class Grid
    include Constants

    def initialize( width = GRID_WIDTH, height = GRID_HEIGHT )
      @width, @height = width, height   # Width and Height in blocks

      @origin = GRID_ORIGIN.offset( (GRID_WIDTH - width) * TILE_WIDTH / 2,
                                    (GRID_HEIGHT - height) * TILE_HEIGHT / 2 )

      @grid = empty_grid
      add_bombs
      set_numbers
    end

    def draw
      each { |block| block.draw }
    end

    def each
      @grid.each { |block| yield block }
    end

    def each_with_index
      @grid.each_with_index { |block, idx| yield block, idx }
    end

    private

    def empty_grid
      grid = []

      (0...@height).each do |row|
        (0...@width).each do |col|
          block = Block.new( @origin.offset( col * TILE_WIDTH, row * TILE_HEIGHT ) )
          block.show if rand( 0..1 ) == 1
          block.mark if rand( 0..1 ) == 1 && block.hidden?
          grid << block
        end
      end

      grid
    end

    def add_bombs
      bombs.times do
        place = 0

        loop do
          place = rand( 0...@grid.size )
          break unless @grid[place].bomb?
        end

        @grid[place].add_bomb
      end
    end

    def set_numbers
      each_with_index do |block, idx|
        block.number = neighbouring_bombs( idx ) unless block.bomb?
      end
    end

    def neighbouring_bombs( idx )
      neighbours( idx ).select { |idx| @grid[idx].bomb? }.size
    end

    def neighbours( idx )
      neighs = []

      neighs << idx - (@width + 1) if idx - (@width + 1) >= 0
      neighs << idx - @width       if idx - @width >= 0
      neighs << idx - (@width - 1) if idx - (@width - 1) >= 0

      neighs << idx - 1 if idx > 0
      neighs << idx + 1 if idx + 1 < @grid.size

      neighs << idx + (@width - 1) if idx + (@width - 1) < @grid.size
      neighs << idx + @width       if idx + @width  < @grid.size
      neighs << idx + (@width + 1) if idx + (@width + 1)  < @grid.size

      neighs
    end

    def bombs
      case @width
      when 8..9 then 10   # Easy   8x8 or 9x9
      when 16   then 46   # Medium 16x16
      else 99             # Hard   30x16
      end
    end
  end
end
