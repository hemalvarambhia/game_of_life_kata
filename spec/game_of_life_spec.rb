require 'world'
describe 'Game of Life' do
  subject(:next_generation) do
    World.new(world).next_generation
  end
  
  describe "A world that looks like #{['..', '..']}" do
    let(:world) do
      [
        '..',
        '..'
      ]
    end

    it "looks like #{['..', '..']} in the next generation" do
      expect(next_generation).to eq ['..','..']
    end
  end

  describe "A world that looks like #{['*.', '..']}" do
    let(:world) do
      [
        '*.',
        '..'
      ]
    end

    it "looks like #{['..', '..']} in the next generation" do
      expect(next_generation).to eq ['..','..']
    end
  end

  describe "A world that looks like #{['**', '..']}" do
    let(:world) do
      [
        '**',
        '..'
      ]
    end

    it "looks like #{['..','..']} in the next generation" do
      expect(next_generation).to eq ['..', '..']
    end
  end

  describe "A world that looks like #{['*.', '**']}" do
    let(:world) do
      [
        '*.',
        '**'
      ]
    end

    it "looks like #{['**', '**']} in the next generation" do
      expect(next_generation).to eq ['**', '**']
    end
  end

  describe "A world that looks like #{['**','.*']}" do
    let(:world) do
      [
        '**',
        '.*'
      ]
    end

    it "looks like #{['**', '**']} in the next generation" do
      expect(next_generation).to eq ['**', '**']
    end
  end

  describe "Block" do
    let(:world) do
      [
        '**',
        '**'
      ]
    end
    it "remains unchanged in the next generation" do
      expect(next_generation).to eq ['**', '**']
    end
  end

  describe "Beehive" do
    let(:world) do
      [
        '.**.',
        '*..*',
        '.**.'
      ]
    end
    
    it "remains unchanged in the next generation" do
      expect(next_generation).to eq ['.**.', '*..*', '.**.']
    end
  end

  describe "Blinker" do
    let(:world) do
      [
        '.*.',
        '.*.',
        '.*.'
      ]
    end

    it "looks like #{['...', '***', '...']} in the next generation" do
      expect(next_generation).to eq ['...', '***', '...']
    end
  end

  describe "Beacon" do
    let(:world) do
      [
        '**..',
        '*...',
        '...*',
        '..**'
      ]
    end
    
    it "looks like #{['**..', '**..', '..**', '..**']} in the next generation" do
      expect(next_generation).to eq ['**..', '**..', '..**', '..**']
    end
  end

  describe "Glider" do
    let(:world) do
      [
        '.*.',
        '..*',
        '***',
        '...'
      ]
    end

    it "looks like #{['...', '*.*', '.**', '.*.']} in the next generation" do
      expect(next_generation).to eq ['...', '*.*', '.**', '.*.']
    end
  end
  
  describe "A world that looks like #{['**', '**', '*.']}" do
    let(:world) do
      [
        '**',
        '**',
        '*.'
      ]
    end

    it "looks like #{['**', '..', '**']} in the next generation" do
      expect(next_generation).to eq ['**', '..', '**']
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
