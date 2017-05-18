require 'rspec'
require 'rspec/its'
require 'yaml'
require_relative '../lib/movie_collection'

describe Cinema::MovieCollection do
  let(:collection) { Cinema::MovieCollection.new('movies.txt') }

  describe '#select' do
    subject { collection.select { |movie| movie.year == 2015 } }
    its(:count) { is_expected.to eq(2) }
    it { is_expected.to all have_attributes(year: 2015) }
  end

  describe '#map' do
    subject(:movies) { collection.map(&:class) }
    it { expect(movies.first).to eq(Cinema::ModernMovie) }
    it { expect(movies.last).to eq(Cinema::NewMovie) }
  end

  describe '#reject' do
    subject(:movies) { collection.reject { |movie| movie.country == 'USA' } }
    it { expect(movies.first.country).not_to eq('USA') }
    its(:count) { is_expected.to eq(84) }
  end

  describe '#sort by' do
    subject(:movies) { collection.sort_by(attribute) }

    context 'year' do
      let(:attribute) { :year }
      it { expect(movies.first.year).to eq(1921) }
      it { expect(movies.last.year).to eq(2015) }
    end

    context 'id' do
      let(:attribute) { :id }
      it { expect(movies.first.id).to eq('tt0012349') }
      it { expect(movies.last.id).to eq('tt3011894') }
    end
  end

  describe '#load_budgets' do
    subject { collection.filter(budget: '$25,000,000') }
    before { collection.load_budgets(YAML.load_file('./budget.yaml')) }
    it { is_expected.to all have_attributes(budget: '$25,000,000') }
  end

end
