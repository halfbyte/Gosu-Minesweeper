module Minesweeper
  # Hold and convert between (row, col) and index.
  class GridPos
    attr_reader :row, :col

    class << self
      attr_reader :width, :height

      def set_limits(width, height)
        @width  = width.to_i
        @height = height.to_i
      end

      def from_index(index)
        new(index / width, index % width)
      end

      # 2 deep is fine so :reek:NestedIterators
      def neighbours(idx)
        neighs  = []
        base    = from_index(idx)

        (-1..1).each do |row|
          (-1..1).each do |col|
            next if row.zero? && col.zero?

            pos = new(base.row + row, base.col + col)
            neighs << pos if pos.valid?
          end
        end

        neighs
      end
    end

    def initialize(row, col)
      @row = row.to_i
      @col = col.to_i
    end

    def to_index
      @row * width + @col
    end

    def valid?
      row.between?(0, height - 1) && col.between?(0, width - 1)
    end

    private

    def width
      self.class.width
    end

    def height
      self.class.height
    end
  end
end
