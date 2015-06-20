require 'block'
require 'gridpos'

module Minesweeper
  # Mined grid
  class Grid
    include Constants

    attr_reader :bombs_left, :failed

    def initialize(width = GRID_WIDTH, height = GRID_HEIGHT)
      @width  = width
      @height = height   # Width and Height in blocks
      GridPos.set_limits(width, height)

      @origin = GRID_ORIGIN.offset((GRID_WIDTH - width) * TILE_WIDTH / 2,
                                   (GRID_HEIGHT - height) * TILE_HEIGHT / 2)

      @grid = empty_grid
      add_bombs
      set_numbers

      @bombs_left = bombs
      @failed = nil
    end

    def draw
      @grid.each(&:draw)
    end

    # Open up all the blocks that are unmarked bombs or incorrectly marked.
    def open_all_bombs
      @grid.each(&:show_if_bad)

      @failed = true
    end

    def mark(point)
      block, _idx = block_from_point point

      return unless block

      toggle(block)
    end

    def open(point)
      block, index = block_from_point point     # block checked, index used

      return unless block

      open_block(GridPos.from_index index)
    end

    def safe_open(point)     # Debugging only
      block, index = block_from_point point     # block checked, index used

      return unless block

      pos = GridPos.from_index index

      if block.bomb?
        toggle(block)
      else
        open_block pos
      end
    end

    def auto_open(point)
      block, index = block_from_point point     # Block checked, index used

      return unless block && block.number > 0 &&
                    block.number == neighbouring_marks(index)

      GridPos.neighbours(index).each do |pos|
        block = grid(pos)
        next unless block.closed? && !block.marked?

        open_block(pos)
      end
    end

    def complete
      @bombs_left == 0 && @grid.all? { |block| block.bomb? == block.marked? }
    end

    private

    def empty_grid
      grid = []

      (0...@height).each do |row|
        (0...@width).each do |col|
          block = Block.new(@origin.offset(col * TILE_WIDTH, row * TILE_HEIGHT))
          grid << block
        end
      end

      grid
    end

    def add_bombs
      bombs.times do
        place = 0

        loop do
          place = rand(0...@grid.size)

          break unless @grid[place].bomb?
        end

        @grid[place].add_bomb
      end
    end

    def set_numbers
      @grid.each_with_index do |block, idx|
        block.number = neighbouring_bombs(idx) unless block.bomb?
      end
    end

    # Returns block and its index from global co-ordinate
    def block_from_point(point)
      pos = GridPos.new(
        (point.y - @origin.y) / TILE_HEIGHT,
        (point.x - @origin.x) / TILE_WIDTH)

      pos.valid? ? [grid(pos), pos.to_index] : [nil, -1]
    end

    # These two functions are mutually recursive
    def open_block(pos)
      block = grid(pos)

      if block.bomb?
        open_all_bombs
      else
        block.show
        open_blanks(pos) if block.empty?
      end
    end

    def open_blanks(base)
      GridPos.neighbours(base.to_index).each do |pos|
        block = grid(pos)
        next unless block.closed? && !block.marked?

        open_block(pos)
      end
    end

    # Number of neighbouring bombs
    def neighbouring_bombs(idx)
      GridPos.neighbours(idx).count { |pos| grid(pos).bomb? }
    end

    # Number of neighbouring marks
    def neighbouring_marks(idx)
      GridPos.neighbours(idx).count { |pos| grid(pos).marked? }
    end

    def bombs
      case @width
      when 8..9 then 10   # Easy   8x8 or 9x9
      when 16   then 46   # Medium 16x16
      else 99             # Hard   30x16
      end
    end

    def grid(pos)
      @grid[pos.to_index]
    end

    def toggle(block)
      return unless block.closed?

      block.toggle_mark

      @bombs_left += block.marked? ? -1 : 1
    end
  end
end
