require './movie.rb'
require 'csv'

class MovieCollection
  attr_accessor :collection

  def initialize(filename)
    unless File.exists?(filename)
      raise ArgumentError, "File #{filename} not found"
    end

    @collection = CSV.read(filename, col_sep: '|').map do |movie|
      Movie.load_from_array(movie)
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
    filtered_collection = @collection
    attrs_hash.each {|key, value|
      filtered_collection = filtered_collection.select { |movie|
          movie.match?(key, value)
      }
    }
    filtered_collection
  end

  def stats(key)
    keys = []
    @collection.each { |movie|
      field = movie.send(key)
      if field.instance_of?(Array)
        field.each {|v| keys.push(v) }
      else
        keys.push(field)
      end
    }
    keys.uniq!
        .sort!

    counts = keys.map {|field|
      self.filter(key => field).count
    }
    keys.zip(counts).to_h
  end
end