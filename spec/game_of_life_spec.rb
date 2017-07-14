require 'ostruct'
describe 'Game of Life' do
  def next_generation(world)
    @world = world
    [
      OpenStruct.new(x: 0, y: 0),
      OpenStruct.new(x: 1, y: 0),
      OpenStruct.new(x: 0, y: 1),
      OpenStruct.new(x: 1, y: 1)
    ].each do |position|
      neighbours = neighbours_of(position)
      kill_cell_at(position) if neighbours.count { |cell| alive?(cell) } < 2
      revive_cell_at(position) if neighbours.count { |cell| alive?(cell) } == 3
    end

    @world
  end

  def neighbours_of(position)
    (position.y - 1..position.y + 1).map do |y|
      (position.x - 1..position.x + 1).map { |x| OpenStruct.new(x: x, y: y) }
    end
      .flatten
      .reject { |coord| coord == position }
      .select { |coord| world_contains?(coord) }
      .map { |coord| cell_at(coord) }
  end

  def world_contains?(coord)
    (0..@world[0].size - 1).include?(coord.x) &&
      (0..@world.size - 1).include?(coord.y)
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

  describe "..\n  .." do
    let(:world) do
      [
        '..',
        '..'
      ]
    end
    
    describe '1st live cell' do
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
  end

  describe "*.\n  .." do
    let(:world) do
      [
        '*.',
        '..'
      ]
    end

    describe 'live cell' do
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
  end

  describe "**\n  .." do
    let(:world) do
      [
        '**',
        '..'
      ]
    end
    
    describe '1st live cell' do
      it 'dies in the next generation' do
        cell_in_next_gen = next_generation(world)[0][0]
      
        expect(cell_in_next_gen).to be_dead
      end
    end

    describe '2nd live cell' do
      it 'also dies in the next generation' do
        cell_in_next_gen = next_generation(world)[0][1]

        expect(cell_in_next_gen).to be_dead
      end

      it 'continues to have 2 neighbouring dead cells' do
        cells_in_next_gen = next_generation(world)
      
        dead_neighbours = [ cells_in_next_gen[1][0], cells_in_next_gen[1][1] ]
        expect(dead_neighbours).to all be_dead
      end
    end
  end

  describe %{*.\n  **} do
    let(:world) do
      [
        '*.',
        '**'
      ]
    end

    describe '1st live cell' do
      it 'lives on to the next generation' do
        cell_in_next_gen = next_generation(world)[0][0]
      
        expect(cell_in_next_gen).to be_alive
      end
    end

    describe '2nd live cell' do
      it 'lives on to the next generation' do
        cell_in_next_gen = next_generation(world)[1][0]
      
        expect(cell_in_next_gen).to be_alive
      end
    end

    describe '3rd live cell' do
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

  describe "**\n  .*" do
    let(:world) do
      [
        '**',
        '.*'
      ]
    end
    
    describe '1st live cell' do
      it 'remains live in the next generation' do
        first_cell = next_generation(world)[0][0]
        
        expect(first_cell).to be_alive
      end
    end

    describe '2nd live cell' do
      it 'remains live in the next generation' do
        second_cell = next_generation(world)[0][1]
        
        expect(second_cell).to be_alive
      end
    end

    describe 'Dead cell' do
      it 'is revived in the next generation' do
        third_cell = next_generation(world)[1][0]
        
        expect(third_cell).to be_alive
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
