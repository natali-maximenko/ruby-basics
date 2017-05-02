module Cinema
  class CollectionByCountry
    def initialize(collection)
      @collection = collection
      values = collection.map(&:country).uniq.sort
      keys = collection.map { |movie| movie.country.downcase.gsub(' ', '-').to_sym }.uniq.sort
      @countries = keys.zip(values).to_h
    end

    def method_missing(m, *args, &block)
      if @countries.key?(m)
        @collection.filter(country:  @countries.fetch(m))
      else
        raise ArgumentError, 'country not exist in collection'
      end
    end
  end
end

