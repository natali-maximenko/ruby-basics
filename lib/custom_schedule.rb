require_relative 'period'
require 'money'

module Cinema
  Hall = Struct.new(:slug, :title, :places)

  class CustomSchedule
    attr_reader :halls, :periods

    def initialize(halls = {}, periods = {}, &block)
      @halls = halls
      @periods = periods
      instance_eval &block
      raise ArgumentError, 'Invalid schedule' if not valid?
    end

    def filters(date)
      @periods[daytime(date)].filters
    end

    def price
      Money.new(@periods[daytime(DateTime.now)].price * 100, 'USD')
    end

    def when?(movie)
      movietime, _ = @periods.detect do |time, param|
        param.filters.any? { |key, value| movie.match?(key, value) }
      end
      if movietime.nil?
        raise ArgumentError, "You can't view movie '#{movie_title}'"
      end
      "From #{@periods[movietime].time.first}:00 to #{@periods[movietime].time.last}:00"
    end

    def valid?
      !@periods.values.combination(2).any? { |p1, p2| p1.intersect?(p2) }
    end

    private

    def daytime(date)
      @periods.keys.detect { |period| period === date.hour }
    end

    def hall(slug, title:, places:)
      @halls[slug] = Cinema::Hall.new(slug, title, places)
    end

    def period(time, &block)
      slug = time.first.to_i..time.last.to_i
      @periods[slug] = Cinema::Period.new(slug, &block)
    end

  end
end
