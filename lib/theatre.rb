require_relative 'movie_collection'
require_relative 'cashbox'
require 'date'
require 'money'

class Theatre < MovieCollection
  include Cashbox
  DAYTIME = {
      morning: {period: :ancient},
      day: {genre: ['Comedy', 'Adventure']},
      evening: {genre: ['Drama', 'Horror']}
  }
  PRICES = {
    morning: Money.new(300, "USD"),
    day: Money.new(500, "USD"),
    evening: Money.new(1000, "USD")
  }
  PERIODS = {
      morning: 8..11,
      day: 12..17,
      evening: 17..23
  }

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
    put_money(get_price)
    puts "You bought a ticket for #{movie.title}"
  end

end
