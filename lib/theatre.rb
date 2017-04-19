require_relative 'movie_collection'
require_relative 'cashbox'
require 'date'

class Theatre < MovieCollection
  include Cashbox
  attr_reader :account
  DAYTIME = {
      morning: {period: :ancient},
      day: {genre: ['Comedy', 'Adventure']},
      evening: {genre: ['Drama', 'Horror']}
  }
  PRICES = {morning: 3, day: 5, evening: 10}
  PERIODS = {
      morning: 8..11,
      day: 12..17,
      evening: 17..23
  }

  def initialize(filename)
    super
    @account = 0
  end

  def show(time)
    daytime = get_daytime(DateTime.parse(time))
    raise ArgumentError, "No movies in this time" if daytime.nil?
    movie = most_popular_movie(filter(DAYTIME[daytime]))
    buy_ticket(movie)
    super(movie)
  end

  def when?(movie_title)
    movie = filter(title: movie_title).first
    raise ArgumentError, "Movie '#{movie_title}' not found" if movie.nil?
    movietime = DAYTIME.keys.detect {|time|
      DAYTIME[time].any? {|key, value| movie.match?(key, value)}
    }
    raise ArgumentError, "You can't view movie '#{movie_title}'" if movietime.nil?
    "From #{PERIODS[movietime].first}:00 to #{PERIODS[movietime].last}:00"
  end

  def get_daytime(date)
    hour = date.hour
    PERIODS.keys.detect { |period| PERIODS[period] === hour }
  end

  def get_price
    daytime = get_daytime(DateTime.now)
    PRICES.fetch(daytime)
  end

  def buy_ticket(movie)
    @account += get_price
    puts "You bought a ticket for #{movie.title}"
  end

end
