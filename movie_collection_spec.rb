require 'rspec'
require './movie_collection.rb'

describe Netflix do
  let(:netflix) { Netflix.new('movies.txt') }

  describe '#pay' do
    it 'updates account' do
      expect { netflix.pay(25) }.to change(netflix, :account).from(0).to(25)
    end

    it 'fails on negative amounts' do
      expect { netflix.pay(-5) }.to raise_error
    end
  end

  describe '#show' do

    context 'when no money on account' do
      it 'raise exception' do
        #expect { netflix.show(genre: 'Comedy', period: :classic) }.to raise_error ArgumentError
      end
    end

    context 'when need more money' do
      #netflix.pay(7)
      it 'raise exception with need no money' do
        #expect { netflix.show(genre: 'Comedy', period: :classic) }.to raise_error ArgumentError
      end
    end

    context 'when have enough money' do
      it 'shows all selected films'
    end


  end
end