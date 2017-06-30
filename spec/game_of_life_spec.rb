describe 'Game of Life' do
  def next_generation(world)
    neighbours = [ world[0][1], world[1][0], world[1][1] ]
    if neighbours.count { |cell| cell == '.' } == 3
      world[0][0] = '.'
    end
      
    world
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
      
      expect(cell_in_next_gen).to eq '.'
    end

    it 'has 3 dead neighbours in the next generation' do
      next_world = next_generation(world)
      cells_in_next_gen =
        [ next_world[0][1], next_world[1][0], next_world[1][1] ]
      
      expect(cells_in_next_gen).to all eq '.'
    end
  end

  describe 'A live cell with 3 dead neighbouring cells' do
    it 'dies in the next generation' do
      world = [
        '*.',
        '..'
      ]
      
      cell_in_next_gen = next_generation(world)[0][0]
      
      expect(cell_in_next_gen).to eq '.'
    end
  end
end
