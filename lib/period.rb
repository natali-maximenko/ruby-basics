require 'set'

module Cinema
  class Period
    def initialize(time, &block)
      @time = time
      @description = ''
      @filters = {}
      @title = ''
      @price = 0
      @hall = []
      raise ArgumentError, 'You need a block to build!' unless block_given?
      instance_eval &block
    end

    def time
      @time
    end

    def description(desc = nil)
      return @description if desc.nil?
      @description = desc
    end

    def filters(**filters)
      return @filters if filters.empty?
      @filters = filters
    end

    def title(title = nil)
      @title = title
    end

    def price(price = nil)
      return @price if price.nil?
      @price = price
    end

    def hall(*halls)
      return @hall if halls.empty?
      @hall = halls
    end

    def intersect?(period)
      period.is_a?(Period) or raise ArgumentError, 'value must be a period'
      hall_intersect?(period) && time_intersect?(period)
    end

    private

    def hall_intersect?(period)
      hall.any? { |h| period.hall.include?(h) }
    end

    def time_intersect?(period)
      time.to_a.to_set.intersect?(period.time.to_a.to_set)
    end
  end
end
