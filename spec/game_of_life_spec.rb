describe 'Game of Life' do
  describe 'A dead cell with 3 dead neighbouring cells' do
    let(:world) do
      [
        '..',
        '..'
      ]
    end

    def next_generation(world)
      world
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
end
