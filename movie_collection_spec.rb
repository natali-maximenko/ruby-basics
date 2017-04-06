require 'rspec'
require './movie_collection.rb'

describe Netflix do

  it '#pay' do
    netflix = Netflix.new('movies.txt')
    netflix.pay(25)
    expect(netflix.account).to eq(25)
  end

  describe '#show' do

    context 'when no money on account' do
      netflix = Netflix.new('movies.txt')
      it 'raise exception' do
        expect { netflix.show(genre: 'Comedy', period: :classic) }.to raise_error ArgumentError
      end
    end

    context 'when need more money' do
      netflix = Netflix.new('movies.txt')
      netflix.pay(7)
      it 'raise exception with need no money' do
        expect { netflix.show(genre: 'Comedy', period: :classic) }.to raise_error ArgumentError
      end
    end

    context 'when have enough money' do
      it 'shows all selected films'
    end


  end
end