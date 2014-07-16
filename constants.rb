require 'gosu_enhanced'

module Minesweeper
  module Constants
    include GosuEnhanced

    MARGIN        = 5

    TILE_WIDTH    = 25
    TILE_HEIGHT   = 25
    TILE_SIZE     = Size.new( TILE_WIDTH, TILE_HEIGHT )

    WIDTH         = 30 * TILE_WIDTH + 2 + MARGIN * 2
    HEIGHT        = 16 * TILE_HEIGHT + 2 * MARGIN + 80

    # Colours

    SILVER        = Gosu::Color.new( 0xff, 0xe0, 0xe0, 0xe0 )

  end
end
