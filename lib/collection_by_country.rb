module Cinema
  class CollectionByCountry
    def initialize(collection)
      @collection = collection
      values = collection.map(&:country).uniq.sort
      keys = collection.map { |movie| movie.country.downcase.gsub(' ', '-').to_sym }.uniq.sort
      @countries = keys.zip(values).to_h
    end

    def method_missing(m, *args, &block)
      raise ArgumentError, 'arguments not supported' unless args.empty?
      raise ArgumentError, 'block not supported' if block_given?
      country_name = @countries.fetch(m) { raise ArgumentError, 'country not exist in collection' }
      @collection.filter(country: country_name)
    end

    def respond_to_missing?(method, include_private = false)
      @countries.key?(method) || super
    end
  end
end

