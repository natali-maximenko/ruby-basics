require 'rspec'
require './movie_collection.rb'

describe Netflix do
  let(:netflix) { Netflix.new('movies.txt') }

  describe '#pay' do
    it 'updates account' do
      expect { netflix.pay(25) }.to change(netflix, :account).from(0).to(25)
    end

    it 'fails on negative amounts' do
      expect { netflix.pay(-5) }.to raise_error ArgumentError, "Amount should be positive, -5 passed"
    end
  end

  describe '#show' do
    it 'fails when no money' do
      expect { netflix.show(genre: 'Comedy', period: :classic) }.to raise_error ArgumentError, "You have no money on your account"
    end

    it 'fails when need more money' do
      price = Netflix::PRICES[:classic]
      netflix.pay(1)
      expect { netflix.show(genre: 'Comedy', period: :classic) }.to raise_error ArgumentError, "Need more money. Film cost #{price}, you have #{netflix.account} on your account"
    end

    it 'shows selected film' do
      netflix.pay(5)
      movie = netflix.filter(genre: 'Comedy', period: :classic).first
      start_time = Time.now
      end_time = start_time + 60 * movie.length.to_i
      message = "Now showing: #{movie.title}"+ start_time.strftime(" %I:%M%p") + end_time.strftime(" - %I:%M%p")+"\n"
      expect { netflix.show(genre: 'Comedy', period: :classic) }.to output(message).to_stdout
    end
  end

  describe '#how_match?' do
    it 'fails when film not found' do
      expect { netflix.how_much?('Mortal Combat') }.to raise_error ArgumentError, "Movie 'Mortal Combat' not found"
    end

    it 'get right movie price by period' do
      prices = Netflix::PRICES
      prices.each_pair {|movie_period, movie_price|
        price = netflix.how_much?(netflix.filter(period: movie_period).first.title)
        expect(price).to eq(movie_price)
      }
    end
  end
end

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