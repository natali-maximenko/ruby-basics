require 'rspec'
require './movie_collection.rb'

describe Netflix do
  before do
    @netflix = Netflix.new('movies.txt')
  end

  it '#pay' do
    @netflix.pay(25)
    expect(@netflix.account).to eq(25)
  end

  it 'when no money on account' do
    @netflix.show(genre: 'Comedy', period: :classic)
    it 'raise exception' do
      expect().to raise_error ArgumentError
    end
  end

end