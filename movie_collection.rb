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
    @collection.each {|movie| movie.to_h }
        .sort_by(&field)
  end

  def filter(field, value)
    @collection.find_all { |movie| movie.get_var(field).include?(value) }
  end

  def stats(field, value=nil)
    if field == :director
      @collection.group_by { |movie| movie.get_var(field) } # get arrays by field
          .sort_by(&:first) # sort by field
          .each { |attr, movies| puts "#{attr}: #{movies.count} films" }
    elsif field == :actors
      @collection.select { |movie| movie.get_var(field).include?(value) }
          .group_by { |movie| value }
          .sort_by(&:first) # sort by field
          .each { |attr, movies| puts "#{attr}: #{movies.count} films" }
    end

  end
end