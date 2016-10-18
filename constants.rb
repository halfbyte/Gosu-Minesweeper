require 'gosu_enhanced'

module Minesweeper
  # Game Constants
  # Obviously this will elicit :reek:TooManyConstants
  module Constants
    include GosuEnhanced

    MARGIN        = 5

    TILE_WIDTH    = 25
    TILE_HEIGHT   = 25
    TILE_SIZE     = Size.new(TILE_WIDTH, TILE_HEIGHT)

    GRID_WIDTH    = 30
    GRID_HEIGHT   = 16
    GRID_SIZE     = Size.new(GRID_WIDTH * TILE_WIDTH, GRID_HEIGHT * TILE_HEIGHT)

    WIDTH         = GRID_WIDTH * TILE_WIDTH + 2 + MARGIN * 2
    HEIGHT        = GRID_HEIGHT * TILE_HEIGHT + 2 * MARGIN + 80

    GRID_ORIGIN   = Point.new(MARGIN + 1,
                              HEIGHT - MARGIN - (GRID_HEIGHT * TILE_HEIGHT + 2))

    # Colours

    SILVER        = Gosu::Color.new(0xffe0e0e0)

    DISPLAY       = Gosu::Color.new(0xffd00000)

    BLUE1         = Gosu::Color.new(0xff1c18ff)
    GREEN2        = Gosu::Color.new(0xff018500)
    RED3          = Gosu::Color.new(0xfffe1800)
    PURPLE4       = Gosu::Color.new(0xff090788)
    MAROON5       = Gosu::Color.new(0xff850700)
    CYAN6         = Gosu::Color.new(0xff0b8586)
    BLACK7        = Gosu::Color::BLACK
    GREY8         = Gosu::Color.new(0xff505050)

    OVERLAY_BG    = Gosu::Color.new(0xe0ffffff) # Translucent white
    SHADOW        = Gosu::Color.new(0x80000000)

    NUMBERS       = [0, BLUE1, GREEN2, RED3, PURPLE4,
                     MAROON5, CYAN6, BLACK7, GREY8].freeze
  end
end
