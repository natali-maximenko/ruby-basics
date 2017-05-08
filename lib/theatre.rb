require_relative 'movie_collection'
require_relative 'cashbox'
require_relative 'schedule_builder'
require 'date'
require 'money'

module Cinema
  class Theatre < MovieCollection
    attr_reader :schedule
    include Cashbox

    def initialize(filename, &block)
      super(filename)
      @schedule = ScheduleBuilder.build(&block)
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
