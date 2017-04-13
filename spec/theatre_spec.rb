require 'rspec'
require_relative '../lib/theatre'

describe Theatre do
  let(:theatre) { Theatre.new('movies.txt') }

  describe '#show' do
    subject { theatre.show(period) }

    context 'when not existed period' do
      let(:period) { :night }
      it { expect { subject }.to raise_error ArgumentError, 'Daytime night is not valid' }
    end

    context 'show film by period' do
      let(:period) { :morning }
      it { expect { subject }.to output("Now showing: Casablanca 09:18 - 11:00\n").to_stdout }
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
      it { is_expected.to eq(:evening) }
    end
  end
end