module Cinema
  class Period
    def initialize(time, &block)
      @time = time
      @description = ''
      @filters = {}
      @title = ''
      @price = 0
      @hall = []
      raise 'You need a block to build!' unless block_given?
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
  end
end
