require 'rspec'
require './movie_collection.rb'

describe Netflix do
  let(:netflix) { Netflix.new('movies.txt') }

  describe '#pay' do
    it 'updates account' do
      expect { netflix.pay(25) }.to change(netflix, :account).from(0).to(25)
    end

    it 'fails on negative amounts' do
      expect { netflix.pay(-5) }.to raise_error NegativeAmount
    end
  end

  describe '#show' do
    it 'fails when no money' do
      expect { netflix.show(genre: 'Comedy', period: :classic) }.to raise_error NoMoney
    end

    it 'fails when need more money' do
      netflix.pay(7)
      expect { netflix.show(genre: 'Comedy', period: :classic) }.to raise_error NotEnoughMoney
    end

    it 'shows all selected films' do

    end
  end
end