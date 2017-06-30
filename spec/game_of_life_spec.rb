describe 'Game of Life' do
  def next_generation(world)
    neighbours = [ world[0][1], world[1][0], world[1][1] ]
    if neighbours.count { |cell| cell == '*' } < 2
      world[0][0] = '.'
    end

    neighbours = [ world[0][0], world[1][0], world[1][1] ]
    if neighbours.count { |cell| cell == '*' } < 2
      world[0][1] = '.'
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

      next_gen_neighbours =
        [ next_world[0][1], next_world[1][0], next_world[1][1] ]
      expect(next_gen_neighbours).to all eq '.'
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
      
      expect(cell_in_next_gen).to eq '.'
    end

    it 'has 3 dead neighbours in the next generation' do
      next_world = next_generation(world)

      next_gen_neighbours =
        [ next_world[0][1], next_world[1][0], next_world[1][1] ]
      expect(next_gen_neighbours).to all eq '.'
    end
  end

  describe 'A live cell with 1 live neighbour and 2 dead ones' do
    it 'dies in the next generation' do
      world = [
        '**',
        '..'
      ]

      cell_in_next_gen = next_generation(world)[0][0]
      
      expect(cell_in_next_gen).to eq '.'
    end

    describe 'The neighbouring live cell' do
      it 'also dies in the next generation' do
        world = [
          '**',
          '..'
        ]

        cell_in_next_gen = next_generation(world)[0][1]

        expect(cell_in_next_gen).to eq '.'
      end
    end

    it 'continues to have 2 neighbouring dead cells'
  end
end
