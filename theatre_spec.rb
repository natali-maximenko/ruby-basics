require 'rspec'
require './theatre.rb'

describe Theatre do
  let(:theatre) { Theatre.new('movies.txt') }

  describe '#show' do
    it 'fails when not existed period' do
      expect { theatre.show(:night) }.to raise_error ArgumentError, "Daytime night is not valid"
    end

    it 'film by selected period' do
      movie = theatre.filter(period: :ancient).first
      start_time = Time.now
      end_time = start_time + 60 * movie.length.to_i
      message = "Now showing: #{movie.title}"+ start_time.strftime(" %I:%M%p") + end_time.strftime(" - %I:%M%p")+"\n"
      expect { theatre.show(:morning) }.to output(message).to_stdout
    end
  end

  describe '#when?' do
    it 'fails when film not found' do
      expect { theatre.when?('Mortal Combat') }.to raise_error ArgumentError, "Movie 'Mortal Combat' not found"
    end

    it 'fails when not shown on any period' do
      movie = theatre.filter(genre: 'Western').first
      expect { theatre.when?(movie.title) }.to raise_error ArgumentError, "You can't view movie '#{movie.title}'"
    end

    it 'get period name for film' do
      period = theatre.when?('American History X')
      expect(period).to eq('evening')
    end
  end
end