require_relative 'movie_collection'
require_relative 'cashbox'
require_relative 'hall'
require_relative 'period'
require 'date'
require 'money'

module Cinema
  class Theatre < MovieCollection
    attr_reader :halls, :periods
    include Cashbox
    FILTERS = {
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
    MOVIE_ATTRS = [:link, :title, :year, :country, :date, :genre, :length, :rating, :director, :actors, :period]

    def initialize(filename, &block)
      super(filename)
      @halls = {}
      @periods = {}
      instance_eval &block if block_given?
    end

    def show(time)
      daytime = daytime(DateTime.parse(time))
      raise ArgumentError, 'No movies in this time' if daytime.nil?
      movies = custom_timetable? ? filter_by_timetable(@periods[daytime].filters) : filter(FILTERS[daytime])
      movie = most_popular_movie(movies)
      buy_ticket(movie)
      super(movie)
    end

    def when?(movie_title)
      movie = filter(title: movie_title).first
      raise ArgumentError, "Movie '#{movie_title}' not found" if movie.nil?
      movietime, _ = FILTERS.detect do |time, filters|
        filters.any? { |key, value| movie.match?(key, value) }
      end
      if movietime.nil?
        raise ArgumentError, "You can't view movie '#{movie_title}'"
      end
      "From #{PERIODS[movietime].first}:00 to #{PERIODS[movietime].last}:00"
    end

    def filter_by_timetable(**filters)
      attr_filters, other_filters = filters.partition { |k, v| MOVIE_ATTRS.include?(k) }
        .map(&:to_h)
      filter(attr_filters)
    end

    def daytime(date)
      if custom_timetable?
        daytime = @periods.keys.detect { |period| period === date.hour }
      else
        daytime = PERIODS.keys.detect { |period| PERIODS[period] === date.hour }
      end
      daytime
    end

    def price
      if custom_timetable?
        price = @periods[daytime(DateTime.now)].price
        price = Money.new(price * 100, 'USD')
      else
        price = PRICES.fetch(daytime(DateTime.now))
      end
      price
    end

    def buy_ticket(movie)
      put_money(price)
      puts "You bought a ticket for #{movie.title}, costs #{price} USD"
    end

    def custom_timetable?
      @periods.any?
    end

    private

    def hall(slug, title:, places:)
      @halls[slug] = Cinema::Hall.new(slug, title, places)
    end

    def period(time, &block)
      slug = time.first.to_i..time.last.to_i
      @periods[slug] = Cinema::Period.new(time, &block)
    end
  end
end
