require 'spec_helper'
require 'themoviedb-api'

describe Cinema::MovieScraper do
  let(:collection) { Cinema::MovieCollection.new('movies.txt') }
  subject(:scraper) { Cinema::MovieScraper.new(collection) }

  describe '#budgets' do
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

  describe '#parse_budget', :vcr do
    VCR.use_cassette('parse_budget') do
      subject { scraper.parse_budget(movie) }
      let(:movie) { collection.filter(id: 'tt0071562').first }
      it 'return budget' do is_expected.to eq '$13,000,000' end
    end
  end

  describe '#movie_details' do
    it 'use #movie_detail' do
      expect(scraper).to receive(:movie_detail).exactly(250).times

      scraper.movie_details
    end
  end

  describe '#movie_detail', :vcr do
    VCR.use_cassette('movie_detail') do
      subject { scraper.movie_detail('tt0071562') }
      it do
        is_expected.to be_a(Tmdb::Movie)
          .and have_attributes(id: 240, original_title: 'The Godfather: Part II', poster_path: '/aPnTXa2TnhXX4HPQMJz0B0ElqqI.jpg', title: 'Крестный отец 2')
      end
    end
  end

end

