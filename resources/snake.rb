class Snake
  def initialize(cell)
    @cells = [cell, Cell.find([cell.xpos-1, cell.ypos])]
    @dead = false
    @cells[0].head!
    @cells[1].activate
  end
    
  attr_reader :cells, :dead

  def length
    @cells.size
  end

  def head
    @cells.first
  end

  def kill!
    @dead = true
  end

  def move(new_cell)
    if new_cell
      if new_cell.active?
        kill!
        return
      end
      head.head = false
      @cells.unshift(new_cell)
      new_cell.head!
      @cells.pop.deactivate unless new_cell.fruit
    else
      kill!
    end
  end
end
