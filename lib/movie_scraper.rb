require 'nokogiri'
require 'open-uri'
require 'yaml'

module Cinema
  class MovieScraper
    TMP_DIR = './upload'
    attr_reader :collection, :file

    def initialize(collection, file = "./budget.yaml")
      @collection = collection
      @file = file
      if (!File.exist?(@file))
        f = File.open(@file, 'w+')
        f.close
      end
    end

    def budgets(from_cache: true)
      from_cache ? load_file : parse_budgets
    end

    def parse_budgets
      @collection.map do |movie| { id: movie.id, budget: parse_budget(movie) } end
    end

    def parse_budget(movie)
      read(movie.id, movie.link) unless File.exist?("#{TMP_DIR}/#{movie.id}")
      page = Nokogiri::HTML(File.open("#{TMP_DIR}/#{movie.id}").read)
      div = page.css('div.txt-block')[9]
      budget = div.css('h4.inline').text.strip == 'Budget:' ? div.children[2].text.strip : nil
    end

    private

    def load_file
      save_file(parse_budgets) if File.empty?(@file)
      YAML.load_file(@file)
    end

    def save_file(budgets)
      File.write(@file, budgets.to_yaml)
    end

    def read(id, url)
      if (!File.exist?("#{TMP_DIR}/#{id}"))
        open("#{TMP_DIR}/#{id}", 'wb') do |file|
          open(url) do |uri|
            file.write(uri.read)
          end
        end
      end
    end

  end
end

