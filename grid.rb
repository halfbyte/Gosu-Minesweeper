require 'block'

module Minesweeper
  # Mined grid
  class Grid
    include Constants

    def initialize( width = GRID_WIDTH, height = GRID_HEIGHT )
      @width, @height = width, height   # Width and Height in blocks
      GridPos.set_limits( width, height )

      @origin = GRID_ORIGIN.offset( (GRID_WIDTH - width) * TILE_WIDTH / 2,
                                    (GRID_HEIGHT - height) * TILE_HEIGHT / 2 )

      @grid = empty_grid
      add_bombs
      set_numbers
    end

    def draw
      each { |block| block.draw }
    end

    # Open up all the blocks that are unmarked bombs or incorrectly marked.
    def open_all_bombs
      each { |block| block.show if block.bomb? != block.marked? }
    end

    def mark( point )
      block, _ = block_from_point point

      block.toggle_mark if block
    end

    def open( point )
      block, index = block_from_point point

      return unless block

      open_block( GridPos.from_index( index ) )
    end

    def auto_open( point )
      block, index = block_from_point point

      return unless block &&
        block.number > 0 &&
        block.number == neighbouring_marks( index )

      neighbours( index ).each do |pos|
        block = grid( pos )
        next unless block.closed? && !block.marked?

        open_block( pos )
      end
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
      to_add  = bombs

      bombs.times do |count|
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
      @grid[index].show

      neighbours( index ).each do |pos|
        block = grid( pos )
        next unless block.closed? && !block.marked?

        open_block( pos )
      end
    end

    def block_from_point( point )
      pos = GridPos.new(
        (point.y - @origin.y) / TILE_HEIGHT,
        (point.x - @origin.x) / TILE_WIDTH )

      pos.valid? ? [grid( pos ), pos.to_index] : [nil, -1]
    end

    def open_block( pos )
      block = grid( pos )

      if block.bomb?
        open_all_bombs
      else
        block.empty? ? open_blanks( pos.to_index ) : block.show
      end
    end

    # Number of neighbouring bombs
    def neighbouring_bombs( idx )
      neighbours( idx ).select { |pos| grid( pos ).bomb? }.size
    end

    # Number of neighbouring marks
    def neighbouring_marks( idx )
      neighbours( idx ).select { |pos| grid( pos ).marked? }.size
    end

    # List of valid neighbpurs
    def neighbours( idx )
      neighs  = []
      base    =  GridPos.from_index( idx )

      (-1..1).each do |row|
        (-1..1).each do |col|
          next if row == 0 && col == 0

          point = GridPos.new( base.row + row, base.col + col )
          neighs << point if point.valid?
        end
      end

      neighs
    end

    def each
      @grid.each { |block| yield block }
    end

    def each_with_index
      @grid.each_with_index { |block, idx| yield block, idx }
    end

    def bombs
      case @width
      when 8..9 then 10   # Easy   8x8 or 9x9
      when 16   then 46   # Medium 16x16
      else 99             # Hard   30x16
      end
    end

    def grid( pos )
      @grid[pos.to_index]
    end
  end

  # Hold and convert between (row, col) and index.
  class GridPos
    attr_reader :row, :col

    def self.set_limits( width, height )
      @width, @height = width.to_i, height.to_i
    end

    def self.from_index( index )
      new( index / width, index % width )
    end

    def initialize( row, col )
      @row, @col = row.to_i, col.to_i
    end

    def to_index
      @row * self.class.width + @col
    end

    def valid?
      row.between?( 0, self.class.height - 1 ) && col.between?( 0, self.class.width - 1 )
    end

    private

    class << self
      attr_reader :width, :height
    end
  end
end
