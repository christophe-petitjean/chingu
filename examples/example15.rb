require 'rubygems'
require File.join(File.dirname($0), "..", "lib", "chingu")
include Gosu
include Chingu

#
# Testing advanced options of timer-trait 
#
class Game < Chingu::Window
  def initialize
    super(640,400)
    self.input = {:esc => :exit}
    switch_game_state(Stuff)
  end
end

class Stuff < GameState
  has_trait :timer
  
  def initialize(options = {})
    super
    self.input = {:t => :toggle, :"1" => :fast, :"2" => :slow}
    @thing = Thing.create(:x => $window.width/2, :y => $window.height / 2 )
    
    every(500, :name => :blink) { @thing.visible? ? @thing.hide! : @thing.show! }
    p timer_exists?(:blink)
  end
  
  def toggle
    stop_timer(:name => :blink)
  end
  
  def fast
    every(200, :name => :blink) { @thing.visible? ? @thing.hide! : @thing.show! }
  end
  
  def slow
    every(1000, :name => :blink) { @thing.visible? ? @thing.hide! : @thing.show! }
  end
  
  def update
    super
    game_objects.destroy_if { |object| object.outside_window? }
  end
end

class Thing < GameObject
  def initialize(options = {})
    super
    @image = Image["circle.png"]
  end
end

Game.new.show