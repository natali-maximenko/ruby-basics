require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'themoviedb-api'

module Cinema
  class MovieScraper
    TMP_DIR = './upload'
    TMDB_KEY = '374ec1b6307d5583ba7e0805836077aa'
    attr_reader :collection, :file

    def initialize(collection, file = "./budget.yaml")
      @collection = collection
      @file = file
      Tmdb::Api.key(TMDB_KEY)
      Tmdb::Api.language("ru")
    end

    def budgets(from_cache: true)
      from_cache ? load_file : parse_budgets
    end

    def parse_budgets
      @collection.map do |movie| { id: movie.id, budget: parse_budget(movie) } end
    end

    def parse_budget(movie)
      html = read(movie.id, movie.link)
      page = Nokogiri::HTML(html)
      div = page.css('div.txt-block')[9]
      budget = div.css('h4.inline').text.strip == 'Budget:' ? div.children[2].text.strip : nil
    end

    def movie_details
      @collection.map do |movie| movie_detail(movie.id) end
    end

    def movie_detail(imdb_id)
      Tmdb::Find.movie(imdb_id, external_source: 'imdb_id').first
    end

    private

    def load_file
      save_file(parse_budgets) unless File.exist?(@file)
      YAML.load_file(@file)
    end

    def save_file(budgets)
      File.open(@file, 'w') do |file| file.write(budgets.to_yaml) end
    end

    def read(id, url)
      File.write("#{TMP_DIR}/#{id}", open(url).read) unless File.exist?("#{TMP_DIR}/#{id}")
      File.open("#{TMP_DIR}/#{id}").read
    end

  end
end

