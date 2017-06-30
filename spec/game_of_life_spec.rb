describe 'Game of Life' do
  describe 'A dead cell with 3 dead neighbouring cells' do
    it 'remains dead in the next generation' do
      world =
        [
          '..',
          '..'
        ]
      
      cell_in_next_gen = world[0][0]
      
      expect(cell_in_next_gen).to eq '.'
    end
  end
end
