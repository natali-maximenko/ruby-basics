require_relative 'movie_collection'
require_relative 'cashbox'
require 'date'
require 'money'

module Cinema
  class Theatre < MovieCollection
    include Cashbox
    DAYTIME = {
      morning: { period: :ancient },
      day: { genre: %w[Comedy Adventure] },
      evening: { genre: %w[Drama Horror] }
    }.freeze
    PRICES = {
      morning: Money.new(300, 'USD'),
      day: Money.new(500, 'USD'),
      evening: Money.new(1000, 'USD')
    }.freeze
    PERIODS = {
      morning: 8..11,
      day: 12..17,
      evening: 17..23
    }.freeze

    def show(time)
      daytime = daytime(DateTime.parse(time))
      raise ArgumentError, 'No movies in this time' if daytime.nil?
      movie = most_popular_movie(filter(DAYTIME[daytime]))
      buy_ticket(movie)
      super(movie)
    end

    def when?(movie_title)
      movie = filter(title: movie_title).first
      raise ArgumentError, "Movie '#{movie_title}' not found" if movie.nil?
      movietime, _ = DAYTIME.detect do |time, filters|
        filters.any? { |key, value| movie.match?(key, value) }
      end
      if movietime.nil?
        raise ArgumentError, "You can't view movie '#{movie_title}'"
      end
      "From #{PERIODS[movietime].first}:00 to #{PERIODS[movietime].last}:00"
    end

    def daytime(date)
      PERIODS.keys.detect { |period| PERIODS[period] === date.hour }
    end

    def price
      PRICES.fetch(daytime(DateTime.now))
    end

    def buy_ticket(movie)
      put_money(price)
      puts "You bought a ticket for #{movie.title}"
    end
  end
end
