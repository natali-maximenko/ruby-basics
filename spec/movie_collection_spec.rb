require 'rspec'
require_relative '../lib/movie_collection'
require_relative '../lib/movie'

describe MovieCollection do
  let(:collection) { MovieCollection.new('movies.txt') }

  describe '#select' do
    subject(:movies2015) { collection.select { |movie| movie.year == 2015 } }
    it { expect(movies2015.count).to eq(2) }
    it { expect(movies2015.first.year).to eq(2015) }
  end

  describe '#map' do
    subject(:movies) { collection.map { |movie| movie.classname } }
    it { expect(movies.first).to eq('ModernMovie') }
    it { expect(movies.last).to eq('NewMovie') }
  end

  describe '#reject' do
    subject(:movies) { collection.reject { |movie| movie.country == 'USA' } }
    it { expect(movies.first.country).not_to eq('USA') }
    it { expect(movies.count).to eq(84) }
  end

  describe '#sort by' do
    subject(:movies) { collection.sort_by(:year) }
    it { expect(movies.first.year).to eq(1921) }
    it { expect(movies.last.year).to eq(2015) }
  end
end