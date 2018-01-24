#!/usr/bin/env ruby -I.

require 'constants'
require 'resources'
require 'grid'
require 'gameover'
require 'renderer'
require 'launchpad'

NUMBER_ELEMENTS = [:up, :down, :left, :right, :session, :user1, :user2, :mixer, :scene1, :scene2, :scene3, :scene4]

module Minesweeper
  # Minesweeper game
  class Game < Gosu::Window
    include Constants

    attr_reader :image, :font, :grid, :start_time

    def initialize(debug = false)
      super(WIDTH, HEIGHT, false)
      self.caption = 'Gosu Minesweeper'

      load_resources

      @debug = debug
      @renderer = Renderer.new(self)

      @launchpad = Launchpad::Device.new(device_name: 'Launchpad Mini')
      @launchpad.flashing_auto

      reset_game
    end

    def needs_cursor?
      true
    end

    def failed?
      @grid && @grid.failed
    end

    def completed?
      @grid && @grid.complete
    end

    def update
      read_midi_data
      if failed? || completed?
        @overlay ||= GameOver.new(self)
      elsif @position
        update_position
      end
    end

    def read_midi_data
      @launchpad.read_pending_actions.each do |action|
        @start_time ||= Time.now
        if action[:state] == :down
          if (action[:type] == :scene8)
          elsif action[:type] == :scene7
            reset_game
          elsif action[:type] == :grid
            show_number(action[:x], action[:y])
          end
        elsif action[:state] == :up
          if (action[:type] == :scene8)
            @mark_mode = !@mark_mode
          elsif action[:type] == :grid
            hide_number
            if @mark_mode
              @position = Position.new(action[:x], action[:y], :mark, true)
            else
              @position = Position.new(action[:x], action[:y], :open, true)
            end
          end
        end
      end
    end

    def show_number(x,y)
      @show_number_for_block = y * 8 + x
    end

    def hide_number
      @show_number_for_block = nil
    end

    def draw
      draw_on_launchpad
      @renderer.draw(@overlay)
    end

    def draw_on_launchpad
      if @mark_mode
        @launchpad.change(:scene8, red: :hi, green: :off, mode: :flashing)
      else
        @launchpad.change(:scene8, red: :off, green: :off, mode: :flashing)
      end

      if @show_number_for_block.nil?
        render_numbers(@grid.bombs_left, {red: :hi, green: :off})
      else
        if @grid.full_grid[@show_number_for_block].closed?
          render_numbers(12, {red: :off, green: :off})
        else
          render_numbers(@grid.full_grid[@show_number_for_block].number, {red: :off, green: :hi})
        end
      end
      @grid.full_grid.each_with_index do |block, i|
        y = (i / 8).floor
        x = (i % 8).floor
        if block.closed?
          if block.marked?
            @launchpad.change(:grid, x: x, y: y, green: :off, red: :hi)
          else
            @launchpad.change(:grid, x: x, y: y, green: :medium, red: :off)
          end
        else
          if block.bomb?
            @launchpad.change(:grid, x: x, y: y, green: :off, red: :hi)
          elsif block.number > 0
            @launchpad.change(:grid, x: x, y: y, green: :medium, red: :medium)
          else
            @launchpad.change(:grid, x: x, y: y, green: :off, red: :off)
          end
        end
      end
    end

    def render_numbers(num, options)
      0.upto(11) do |i|
        if i < num
          @launchpad.change(NUMBER_ELEMENTS[i], options)
        else
          @launchpad.change(NUMBER_ELEMENTS[i], {red: :off, green: :off})
        end
      end
    end

    def button_down(code)
      return @position = Position.new(mouse_x, mouse_y, :auto_open) \
        if button_down?(Gosu::MsLeft) && button_down?(Gosu::MsRight)

      case code
      when Gosu::KbEscape then close if @debug
      when Gosu::KbR      then reset_game
      when Gosu::MsRight  then @position = Position.new(mouse_x, mouse_y, :mark)

      when Gosu::MsMiddle
        @position = Position.new(mouse_x, mouse_y, :safe_open) if @debug
      end
    end

    # Left Mouse Button is detected on release to avoid it being triggered
    # accidentally on a bombed square.
    def button_up(code)
      @start_time ||= Time.now

      return unless code == Gosu::MsLeft && !button_down?(Gosu::MsRight)

      @position = Position.new(mouse_x, mouse_y, :open)
    end

    private

    def reset_game
      @overlay = nil
      @grid = Grid.new(8,8)
      @start_time = nil
      @mark_mode = false
      @show_number_for_block = nil
    end

    def load_resources
      @image = ResourceLoader.images
      @font  = ResourceLoader.fonts

      Block.setup_graphics(self)
    end

    def update_position
      @grid.send(@position.op, @position.point, @position.exact)

      @position = nil
    end
  end

  # Hold the mouse position and the operation to perform
  class Position
    include GosuEnhanced

    attr_reader :point, :op, :exact

    # This reeks of :reek:UncommunicativeParameterName
    def initialize(x, y, op, exact = false)
      puts "#{x}, #{y} - #{op} - #{exact}"
      @point = Point.new(x, y)
      @op = op
      @exact = exact
    end
  end
end

Minesweeper::Game.new(:debug).show
