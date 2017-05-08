require_relative 'hall'
require_relative 'period'
require 'money'
require 'set'

module Cinema
  class CustomSchedule
    attr_reader :halls, :periods

    def initialize(&block)
      @halls = {}
      @periods = {}
      instance_eval &block
      #raise ArgumentError, 'Invalid schedule' if not valid?
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
      "From #{@periods[movietime].time.first} to #{@periods[movietime].time.last}"
    end

    def valid?
      times = {}
      @halls.keys.each do |hall|
        period = @periods.keys.select { |time| @periods[time].hall.include?(hall) }
        timemap = period.flat_map { |range| range.to_a }
        times[hall] = timemap.to_set
      end
      times.values.combination(2).all? { |t1, t2| not t1.intersect?(t1) }
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
      @periods[slug] = Cinema::Period.new(time, &block)
    end

  end
end
