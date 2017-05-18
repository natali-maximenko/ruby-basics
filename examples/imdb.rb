require_relative '../lib/movie_collection'
require_relative '../lib/movie_scraper'

movies = Cinema::MovieCollection.new('movies.txt')
parser = Cinema::MovieScraper.new(movies)
movies.load_budgets(parser.budgets)
