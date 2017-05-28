require_relative 'movie_collection'
require_relative 'cashbox'
require_relative 'schedule'
require_relative 'custom_schedule'

module Cinema
  class Theatre < MovieCollection
    include Cashbox
    attr_reader :schedule

    def initialize(filename, &block)
      super(filename)
      @schedule = block_given? ? CustomSchedule.new(&block) : Schedule.new
    end

    def show(time)
      movies = filter(@schedule.filters(DateTime.parse(time)))
      movie = most_popular_movie(movies)
      buy_ticket(movie)
      super(movie)
    end

    def when?(movie_title)
      movie = filter(title: movie_title).first
      raise ArgumentError, "Movie '#{movie_title}' not found" if movie.nil?
      @schedule.when?(movie)
    end

    def buy_ticket(movie)
      price = @schedule.price
      put_money(price)
      puts "You bought a ticket for #{movie.title}, costs #{price} USD"
    end
  end
end
