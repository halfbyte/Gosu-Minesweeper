require 'gosu_enhanced'

module Minesweeper
  # Game Constants
  module Constants
    include GosuEnhanced

    MARGIN        = 5

    TILE_WIDTH    = 25
    TILE_HEIGHT   = 25
    TILE_SIZE     = Size.new( TILE_WIDTH, TILE_HEIGHT )

    GRID_WIDTH    = 30
    GRID_HEIGHT   = 16
    GRID_SIZE     = Size.new( GRID_WIDTH * TILE_WIDTH, GRID_HEIGHT * TILE_HEIGHT )

    WIDTH         = GRID_WIDTH * TILE_WIDTH + 2 + MARGIN * 2
    HEIGHT        = GRID_HEIGHT * TILE_HEIGHT + 2 * MARGIN + 80

    GRID_ORIGIN   = Point.new(
                      MARGIN + 1,
                      (HEIGHT - MARGIN) - (GRID_HEIGHT * TILE_HEIGHT + 2) )

    # Colours

    SILVER        = Gosu::Color.new( 0xff, 0xe0, 0xe0, 0xe0 )
  end
end
