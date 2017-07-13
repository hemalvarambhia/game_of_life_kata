require 'ostruct'
describe 'Game of Life' do
  def next_generation(world)
    @world = world
    position = OpenStruct.new(x: 0, y: 0)
    neighbours = neighbours_of(position)
    kill_cell_at(position) if neighbours.count { |cell| alive?(cell) } < 2
    revive_cell_at(position) if neighbours.count { |cell| alive?(cell) } == 3
    
    position = OpenStruct.new(x: 1, y: 0)
    neighbours = neighbours_of(position)
    kill_cell_at(position) if neighbours.count { |cell| alive?(cell) } < 2
    revive_cell_at(position) if neighbours.count { |cell| alive?(cell) } == 3

    
    
    @world
  end

  def neighbours_of(position)
    [
      OpenStruct.new(x: position.x - 1, y: position.y - 1),
      OpenStruct.new(x: position.x, y: position.y - 1),
      OpenStruct.new(x: position.x + 1, y: position.y - 1),
      OpenStruct.new(x: position.x - 1, y: position.y),
      OpenStruct.new(x: position.x + 1, y: position.y),
      OpenStruct.new(x: position.x - 1, y: position.y + 1),
      OpenStruct.new(x: position.x, y: position.y + 1),
      OpenStruct.new(x: position.x + 1, y: position.y + 1),
    ].
      reject { |coord| coord.x < 0 || coord.y < 0 }.
      map { |coord| cell_at(coord) }
  end

  def revive_cell_at(position)
    @world[position.y][position.x] = '*'
  end

  def kill_cell_at(position)
    @world[position.y][position.x] = '.'
  end

  def cell_at(position)
    @world[position.y][position.x]
  end

  def alive?(cell)
    cell == '*'
  end

  describe 'A dead cell with 3 dead neighbouring cells' do
    let(:world) do
      [
        '..',
        '..'
      ]
    end

    it 'remains dead in the next generation' do
      cell_in_next_gen = next_generation(world)[0][0]
      
      expect(cell_in_next_gen).to be_dead
    end

    it 'has 3 dead neighbours in the next generation' do
      next_world = next_generation(world)

      next_gen_neighbours =
        [ next_world[0][1], next_world[1][0], next_world[1][1] ]
      expect(next_gen_neighbours).to all be_dead
    end
  end

  describe 'A live cell with 3 dead neighbouring cells' do
    let(:world) do
      [
        '*.',
        '..'
      ]
    end

    it 'dies in the next generation' do
      cell_in_next_gen = next_generation(world)[0][0]
      
      expect(cell_in_next_gen).to be_dead
    end

    it 'has 3 dead neighbours in the next generation' do
      next_world = next_generation(world)

      next_gen_neighbours =
        [ next_world[0][1], next_world[1][0], next_world[1][1] ]
      expect(next_gen_neighbours).to all be_dead
    end
  end

  describe 'A live cell with 1 live neighbour and 2 dead ones' do
    let(:world) do
      [
        '**',
        '..'
      ]
    end

    it 'dies in the next generation' do
      cell_in_next_gen = next_generation(world)[0][0]
      
      expect(cell_in_next_gen).to be_dead
    end

    describe 'The neighbouring live cell' do
      it 'also dies in the next generation' do
        cell_in_next_gen = next_generation(world)[0][1]

        expect(cell_in_next_gen).to be_dead
      end
    end

    it 'continues to have 2 neighbouring dead cells' do
      cells_in_next_gen = next_generation(world)
      
      dead_neighbours = [ cells_in_next_gen[1][0], cells_in_next_gen[1][1] ]
      expect(dead_neighbours).to all be_dead
    end
  end

  describe 'A live cell with 2 live neighbours and 1 dead one' do
    let(:world) do
      [
        '*.',
        '**'
      ]
    end

    it 'lives on to the next generation' do
      cell_in_next_gen = next_generation(world)[0][0]
      
      expect(cell_in_next_gen).to be_alive
    end

    describe '2nd live neighbouring cell' do
      it 'lives on to the next generation' do
        cell_in_next_gen = next_generation(world)[1][0]
      
        expect(cell_in_next_gen).to be_alive
      end
    end

    describe '3rd live neighbouring cell' do
      it 'lives on to the next generation' do
        cell_in_next_gen = next_generation(world)[1][0]
        
        expect(cell_in_next_gen).to be_alive
      end
    end

    describe 'Dead neighbouring cell' do
      it 'is revived' do
        cell_in_next_gen = next_generation(world)[0][1]
        
        expect(cell_in_next_gen).to be_alive
      end
    end
  end

  RSpec::Matchers.define :be_dead do
    match do |cell|
      cell == '.'
    end
  end

  RSpec::Matchers.define :be_alive do
    match do |cell|
      cell == '*'
    end
  end
end
