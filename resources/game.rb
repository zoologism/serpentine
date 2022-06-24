class Game

  include Calcs

  @@high_score = 0

  def initialize(size)
    @grid = Grid.new(size, size)
    @score = 0
    @fruits = 0
    @level = 2
    @levelled = true
    @snake = Snake.new(Cell.find([8, 10]))
    @bonus_cell, @fruit_cell = Cell.inactive.sample(2)
    @fruit_cell.fruit!
    @keys = {
      "up" => ["w", "W", "k", "\e[A"],
      "down" => ["s", "S", "j", "\e[B"],
      "left" => ["a", "A", "h", "\e[D"],
      "right" => ["d", "D", "l", "\e[C"]
    }
  end

  attr_reader :grid

  def board
    system "clear"
    logo
    @grid.draw
  end

  def scoreline
    print "Score: #{@score} | Level: #{@level - 1} | High score: #{@@high_score}"
    if Cell.all.any?(&:bonus)
      print " | #{(@bonus_cell.bonus_expiry - Time.now).ceil(1)}"
    end
    puts
  end


  def get_input(input)
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
    return input
  end

  def check_bonus_time
    if Time.now > @bonus_cell.bonus_expiry
      @bonus_cell.bonus = false
    end
  end
  
  def bonus_spawner
    unless Cell.all.any?(&:bonus)
      bonus = [*(1..10)].sample
      if bonus == 1
        @bonus_cell = Cell.inactive.sample
        @bonus_cell.bonus!(4)
      end
    end
  end

  def play
    board
    puts "          ↑ W  ↓ S  ← A  → D"
    key = ""

    until @keys.flatten(2).include? key
      key = get_input(STDIN.getch)
    end

    until @snake.dead do
      begin
        key = Timeout::timeout(1.0/@level){ get_input(STDIN.getch) }
      rescue Timeout::Error
        key
      end

      if @keys.flatten(2).include? key
        dir = @keys.find{ |k, v| v.include? key }.first
      end
      move(dir)

      if @fruits > 1 && Calcs::triangular(@fruits) && !@levelled
        @level += 1
        @levelled = true
      end

      check_bonus_time if @bonus_cell.bonus
      board
      scoreline
    end
    lost
  end

  def move(dir)
    head = @snake.head
    current_cell = [head.xpos, head.ypos]
    directions = {
      "down" => current_cell.map.with_index{ |z, i| i == 1 ? z - 1 : z },
      "up" => current_cell.map.with_index{ |z, i| i == 1 ? z + 1 : z },
      "right" => current_cell.map.with_index{ |z, i| i == 0 ? z + 1 : z },
      "left" => current_cell.map.with_index{ |z, i| i == 0 ? z - 1 : z }
    }
    next_cell = Cell.find(directions[dir])
    @snake.move(next_cell)
    head = @snake.head
    if head.fruit
      head.fruit = false
      Cell.inactive.sample.fruit!
      @score += 1
      @fruits += 1
      bonus_spawner
      @levelled = false
    elsif head.bonus
      head.bonus = false
      @score += 5
    end
  end

  def lost
    board
    scoreline
    @@high_score = @score if @score > @@high_score
    return true
  end

end
