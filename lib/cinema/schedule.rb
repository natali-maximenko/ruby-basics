require_relative 'movie'

module Cinema
  class Schedule
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

    def filters(date)
      FILTERS[daytime(date)]
    end

    def price
      PRICES.fetch(daytime(DateTime.now))
    end

    def when?(movie)
      movietime, _ = FILTERS.detect do |time, filters|
        filters.any? { |key, value| movie.match?(key, value) }
      end
      if movietime.nil?
        raise ArgumentError, "You can't view movie '#{movie.title}'"
      end
      "From #{PERIODS[movietime].first}:00 to #{PERIODS[movietime].last}:00"
    end

    private

    def daytime(date)
      daytime = PERIODS.keys.detect { |period| PERIODS[period] === date.hour }
      raise ArgumentError, 'No movies in this time' if daytime.nil?
      daytime
    end

  end
end
