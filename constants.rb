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

    BLUE1         = Gosu::Color.new( 0xff, 0x00, 0x00, 0xA0 )
    GREEN2        = Gosu::Color.new( 0xff, 0x00, 0xA0, 0x00 )
    RED3          = Gosu::Color.new( 0xff, 0xA0, 0x00, 0x00 )
    PURPLE4       = Gosu::Color.new( 0xff, 0x90, 0x00, 0x90 )
    MAROON5       = Gosu::Color.new( 0xff, 0xB0, 0x50, 0xB0 )
    CYAN6         = Gosu::Color.new( 0xff, 0x00, 0x80, 0x80 )
    BLACK7        = Gosu::Color::BLACK
    GREY8         = Gosu::Color.new( 0xff, 0x50, 0x50, 0x50 )

    NUMBERS       = [0, BLUE1, GREEN2, RED3, PURPLE4, MAROON5, CYAN6, BLACK7, GREY8]
  end
end
