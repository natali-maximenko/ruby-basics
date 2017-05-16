require_relative '../lib/movie_collection'
require_relative '../lib/movie_scraper'

movies = Cinema::MovieCollection.new('movies.txt')
parser = Cinema::MovieScraper.new(movies.first.link)
parser.save_budget
parser.print_budget
