require_relative 'movie'
require 'csv'
require 'date'

class MovieCollection
  attr_accessor :collection
  TIMEFORMAT = '%I:%M'

  def initialize(filename)
    unless File.exists?(filename)
      raise ArgumentError, "File #{filename} not found"
    end

    @collection = CSV.read(filename, col_sep: '|').map do |movie|
      Movie.create(movie, self)
    end
  end

  def all
    @collection
  end

  def sort_by(field)
    @collection.map
               .sort_by { |movie| movie.send(field)  }
  end

  def filter(**attrs_hash)
    attrs_hash.reduce(@collection) { |memo, (key, value)|
      memo.select { |movie| movie.match?(key, value) }
    }
  end

  def stats(key)
    @collection.flat_map(&key)
               .sort
               .group_by { |v| v }
               .map { |v, values| {v => values.count} }
  end

  def show(movie)
    start_time = Time.now
    end_time = start_time + 60 * movie.length.to_i
    puts "Now showing: %s %s - %s" % [movie.title, start_time.strftime(TIMEFORMAT), end_time.strftime(TIMEFORMAT)]
  end
end