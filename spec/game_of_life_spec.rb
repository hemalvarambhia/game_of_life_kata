require 'ostruct'
describe 'Game of Life' do
  class World
    def initialize(world)
      @initial = world
      @world = world.map { |cells| cells.clone }
    end
    
    def next_generation
      positions.each do |position|
        neighbours = neighbours_of(position)
        kill_cell_at(position) if number_of_live(neighbours) < 2
        kill_cell_at(position) if number_of_live(neighbours) > 3
        revive_cell_at(position) if number_of_live(neighbours) == 3
      end

      @world
    end

    private

    def positions
      (0..@initial.size - 1).map do |y|
        (0..@initial[0].size - 1).map { |x| OpenStruct.new(x: x, y: y) }
      end.flatten
    end

    def number_of_live(neighbours)
      neighbours.count { |cell| alive?(cell) }
    end

    def neighbours_of(position)
      (position.y - 1..position.y + 1).map do |y|
        (position.x - 1..position.x + 1).map { |x| OpenStruct.new(x: x, y: y) }
      end
        .flatten
        .reject { |coord| coord == position }
        .select { |coord| contains?(coord) }
        .map { |coord| cell_at(coord) }
    end

    def contains?(coord)
      positions.include? coord
    end

    def revive_cell_at(position)
      @world[position.y][position.x] = '*'
    end

    def kill_cell_at(position)
      @world[position.y][position.x] = '.'
    end

    def cell_at(position)
      @initial[position.y][position.x]
    end

    def alive?(cell)
      cell == '*'
    end
  end

  subject(:next_world) do
    World.new(world).next_generation
  end

  describe "Given a world that looks like #{['..', '..']}" do
    let(:world) do
      [
        '..',
        '..'
      ]
    end

    it "looks like #{['..', '..']} in the next generation" do
      expect(next_world).to eq ['..','..']
    end
  end

  describe "Given a world that looks like #{['*.', '..']}" do
    let(:world) do
      [
        '*.',
        '..'
      ]
    end

    it "looks like #{['..', '..']} in the next generation" do
      expect(next_world).to eq ['..','..']
    end
  end

  describe "Given a world that looks like #{['**', '..']}" do
    let(:world) do
      [
        '**',
        '..'
      ]
    end

    it "looks like #{['..','..']} in the next generation" do
      expect(next_world).to eq ['..', '..']
    end
  end

  describe "Given a world that looks like #{['*.', '**']}" do
    let(:world) do
      [
        '*.',
        '**'
      ]
    end

    it "looks like #{['**', '**']} in the next generation" do
      expect(next_world).to eq ['**', '**']
    end
  end

  describe "Given a world that looks like #{['**','.*']}" do
    let(:world) do
      [
        '**',
        '.*'
      ]
    end

    it "looks like #{['**', '**']} in the next generation" do
      expect(next_world).to eq ['**', '**']
    end
  end

  describe "Given a world that looks like #{['.*.',  '.*.',  '.*.']}" do
    let(:world) do
      [
        '.*.',
        '.*.',
        '.*.'
      ]
    end

    it "looks like #{['...', '***', '...']} in the next generation" do
      expect(next_world).to eq ['...', '***', '...']
    end
  end
  
  describe "Given a world that looks like #{['**', '**', '*.']}" do
    let(:world) do
      [
        '**',
        '**',
        '*.'
      ]
    end

    it "looks like #{['**', '..', '**']} in the next generation" do
      expect(next_world). to eq ['**', '..', '**']
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
