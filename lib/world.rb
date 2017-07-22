require 'ostruct'
class World
  def initialize(world)
    @current_generation = world
    @next_generation = world.map { |cells| cells.clone }
  end
    
  def next_generation
    positions.each do |position|
      neighbours = neighbours_of(position)
      if number_of_live(neighbours) < 2 || number_of_live(neighbours) > 3
        kill_cell_at(position)
      end
      revive_cell_at(position) if number_of_live(neighbours) == 3
    end
    
    @next_generation
  end

  private

  def positions
    (0..@current_generation.size - 1).map do |y|
      (0..@current_generation[0].size - 1).map { |x| coordinate(x, y) }
    end.flatten
  end

  def number_of_live(neighbours)
    neighbours.count { |cell| alive?(cell) }
  end

  def neighbours_of(position)
    (position.y - 1..position.y + 1).map do |y|
      (position.x - 1..position.x + 1).map { |x| coordinate(x, y) }
    end
      .flatten
      .reject { |coord| coord == position }
      .select { |coord| contains?(coord) }
      .map { |coord| cell_at(coord) }
  end

  def contains?(coord)
    positions.include? coord
  end

  def coordinate(x, y)
    OpenStruct.new(x: x, y: y)
  end

  def revive_cell_at(position)
    @next_generation[position.y][position.x] = '*'
  end

  def kill_cell_at(position)
    @next_generation[position.y][position.x] = '.'
  end

  def cell_at(position)
    @current_generation[position.y][position.x]
  end

  def alive?(cell)
    cell == '*'
  end
end
