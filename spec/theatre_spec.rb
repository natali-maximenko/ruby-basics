require 'rspec'
require 'date'
require 'timecop'
require_relative '../lib/theatre'

describe Theatre do
  let(:theatre) { Theatre.new('movies.txt') }

  describe '#show' do
    subject { theatre.show(time) }

    context 'when not existed period' do
      let(:time) { '1:30' }
      it { expect { subject }.to raise_error ArgumentError, 'No movies in this time' }
    end

    context 'show film by period' do
      let(:time) { '18:05' }
      before do
        date = Date.today
        time = Time.local(date.year, date.month, date.day, 18, 0, 0)
        Timecop.freeze(time)
      end

      it "filter, get most popular" do
        films = double
        allow(theatre).to receive(:filter).with({genre: ['Drama', 'Horror']}) { films }
        expect(theatre).to receive(:most_popular_movie).with(films).and_return(double(length: 120, title: 'Modern Times'))

        theatre.show(time)
      end
    end
  end

  describe '#when?' do
    subject { theatre.when?(movie_title) }

    context 'when film not found' do
      let(:movie_title) { 'Mortal Combat' }
      it 'fails' do
        expect { subject }.to raise_error ArgumentError, "Movie 'Mortal Combat' not found"
      end
    end

    context 'when film not shown on any period' do
      let(:movie_title) { 'The Good, the Bad and the Ugly' }
      it { expect { subject }.to raise_error ArgumentError, "You can't view movie 'The Good, the Bad and the Ugly'" }
    end

    context 'when film is shown' do
      let(:movie_title) { 'American History X' }
      it { is_expected.to eq('From 17:00 to 23:00') }
    end
  end
end