require_relative '../lib/cinema/movie_collection'
require_relative '../lib/cinema/movie_scraper'

movies = Cinema::MovieCollection.new('movies.txt')
parser = Cinema::MovieScraper.new(movies)
movies.load_budgets(parser.budgets)
movies.load_detail(parser.movie_details)
movies.save('list.html')
