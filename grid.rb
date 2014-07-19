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

    def mark( pos )
      block, _ = block_from_pos pos

      block.toggle_mark if block
    end

    def open( pos )
      block, index = block_from_pos pos

      return unless block

      block.empty? ? open_blanks( index ) : block.show
    end

    private

    def empty_grid
      grid = []

      (0...@height).each do |row|
        (0...@width).each do |col|
          block = Block.new( @origin.offset( col * TILE_WIDTH, row * TILE_HEIGHT ) )
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

    def open_blanks( index )
      to_open = [index]

      until to_open.empty?
        cur   = to_open.shift
        block = @grid[cur]

        next unless block.closed?

        block.show

        neighbours( cur ).each do |i|
          b = @grid[i]
          to_open << i if b.closed? && b.empty?
        end
      end
    end

    def block_from_pos( pos )
      col = ((pos.x - @origin.x) / TILE_WIDTH).floor
      row = ((pos.y - @origin.y) / TILE_HEIGHT).floor

      if valid_block?( row, col )
        index = row * @width + col
        [@grid[index], index]
      else
        [nil, -1]
      end
    end

    def neighbouring_bombs( idx )
      neighbours( idx ).select { |index| @grid[index].bomb? }.size
    end

    def neighbours( idx )
      neighs = []

      neighbour_offsets.each do |offset|
        index = idx + offset

        neighs << index if valid_index? index
      end

      neighs
    end

    def bombs
      case @width
      when 8..9 then 10   # Easy   8x8 or 9x9
      when 16   then 46   # Medium 16x16
      else 99             # Hard   30x16
      end
    end

    def valid_block?( row, col )
      row.between?( 0, @height - 1 ) && col.between?( 0, @width - 1 )
    end

    def valid_index?( index )
      index.between?( 0, @grid.size - 1 )
    end

    def neighbour_offsets
      [-(@width + 1), -@width, -(@width - 1), -1, 1, @width - 1, @width, @width + 1]
    end
  end
end
