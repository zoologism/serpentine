class Cell

  @@instances = []

  def initialize(x, y)
    @xpos = x
    @ypos = y
    @head = false
    @active = false
    @fruit = false
    @bonus = false
    @@instances << self
  end

  attr_reader :xpos, :ypos, :bonus_expiry
  attr_accessor :fruit, :head, :bonus

  def self.all
    @@instances
  end

  def self.reset
    @@instances = []
  end

  def self.inactive
    @@instances.select{ |i| i.active? == false && i.fruit == false }
  end

  def self.find(coords)
    @@instances.find{ |i| [i.xpos, i.ypos] == coords }
  end

  def active?
    @active
  end

  def fruit!
    @fruit = true
  end

  def bonus!(life)
    @bonus_expiry = Time.now + life
    @bonus = true
  end

  def char
    if @head
      "@".green
    elsif @active
      "o".green
    elsif @fruit
      "%".red
    elsif @bonus
      "£".yellow
    else
      " "
    end
  end

  def head!
    @head = true
    @active = true
  end

  def activate
    @active = true
  end

  def deactivate
    @active = false
    @head = false
  end
  
end

class Grid
  def initialize(width, height)
    @width = width
    @height = height
    @grid = build_grid
  end

  def build_grid
    (1..@height).map{ |y| (1..@width).map{ |x| Cell.new(x, y) } }.reverse
  end

  def grid
    @grid
  end

  def width
    @width
  end

  def height
    @height
  end

  def draw
    puts "__________________________________________"
    @grid.each do |line|
      print "|"
      line.each do |ch|
        print "#{ch.char} "
      end
      puts "|"
    end
    puts "‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"
  end

end

