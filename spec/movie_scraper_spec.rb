require 'rspec'
require 'spec_helper.rb'
require_relative '../lib/movie_scraper'
require_relative '../lib/movie_collection'

describe Cinema::MovieScraper do
  let(:collection) { Cinema::MovieCollection.new('movies.txt') }
  subject(:scraper) { Cinema::MovieScraper.new(collection) }

  describe '#budgets' do
    #subject { scraper.budgets(from_cache: false) }
    #it { is_expected.to be_an(Array) }

    it 'use cache by default' do
      expect(scraper).to receive(:load_file)
      expect(scraper).not_to receive(:parse_budgets)

      scraper.budgets
    end

    it 'when not from cache save budgets to file' do
      expect(scraper).to receive(:parse_budgets)

      scraper.budgets(from_cache: false)
    end
  end

  describe '#parse_budgets' do
    it 'use #parse_budgets' do
      expect(scraper).to receive(:parse_budget).exactly(250).times

      scraper.parse_budgets
    end
  end

  describe '#parse_budget'  do
    subject { scraper.parse_budget(movie) }
    let(:movie) { collection.filter(id: 'tt0071562').first }
    it 'return budget' do
      is_expected.to eq '$13,000,000'
    end
  end

end

