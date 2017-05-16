require 'nokogiri'
require 'open-uri'
require 'yaml'

module Cinema
  MovieBudget = Struct.new(:id, :budget)
  class MovieScraper
    attr_reader :url, :id, :budget

    def initialize(movie_url)
      @url = movie_url
      @id = movie_url.split('/')[4]
      read
      parse_budget
    end

    def save_budget
      str = YAML.dump MovieBudget.new(@id, @budget)
      if (!File.exist?("./upload/#{@id}.yaml"))
        f = File.open("./upload/#{@id}.yaml", 'w+')
        f.close
      end
      File.write("./upload/#{@id}.yaml", str)
    end

    def print_budget
      puts YAML.load_file("./upload/#{@id}.yaml")
    end

    private

    def parse_budget
      html = File.open("./upload/#{@id}").read
      page = Nokogiri::HTML(html)
      div = page.css('div.txt-block')[9]
      title = div.css('h4.inline').text.strip
      @budget = title == 'Budget:' ? div.children[2].text.strip : 'no information'
    end

    def read
      if (!File.exist?("./upload/#{@id}"))
        open("./upload/#{@id}", 'wb') do |file|
          open(@url) do |uri|
            file.write(uri.read)
          end
        end
      end
    end
  end
end

