require_relative 'movie'
require 'csv'
require 'date'

module Cinema
  class MovieCollection
    include Enumerable
    attr_accessor :collection
    TIMEFORMAT = '%H:%M'.freeze
    SHOW_MSG = 'Now showing: %s %s - %s'.freeze

    def initialize(filename)
      unless File.exist?(filename)
        raise ArgumentError, "File #{filename} not found"
      end

      @collection = CSV.read(filename, col_sep: '|').map do |movie|
        Movie.create(movie, self)
      end
    end

    def each(&block)
      @collection.each(&block)
    end

    def all
      @collection
    end

    def genres
      @collection.map(&:genre).flatten.uniq.sort
    end

    def sort_by(field)
      @collection.sort_by(&field)
    end

    def filter(**attrs_hash)
      attrs_hash.reduce(@collection) do |memo, (key, value)|
        memo.select { |movie| movie.match?(key, value) }
      end
    end

    def stats(key)
      @collection.flat_map(&key)
                 .sort
                 .group_by { |v| v }
                 .map { |v, values| { v => values.count } }
    end

    def show(movie)
      start_time = Time.now
      end_time = start_time + 60 * movie.length.to_i
      puts SHOW_MSG % [movie.title, start_time.strftime(TIMEFORMAT), end_time.strftime(TIMEFORMAT)]
    end

    def most_popular_movie(collection)
      collection.sort_by { |movie| movie.rating * rand(0.0..1.5) }.last
    end

    def load_budgets(hash)
      @collection.each do |movie|
        param = hash.select { |info| movie.id == info[:id] }.first
        movie.budget = param[:budget] unless param.nil?
      end
    end
  end
end
