require './movie.rb'
require 'csv'
require 'date'

class MovieCollection
  attr_accessor :collection

  def initialize(filename)
    unless File.exists?(filename)
      raise ArgumentError, "File #{filename} not found"
    end

    @collection = CSV.read(filename, col_sep: '|').map do |movie|
      case movie[2].to_i
        when 1900..1944
          AncientMovie.load_from_array(movie)
        when 1945..1967
          ClassicMovie.load_from_array(movie)
        when 1968..1999
          ModernMovie.load_from_array(movie)
        else
          NewMovie.load_from_array(movie)
      end
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
    puts "Now showing: #{movie.title}" + start_time.strftime(" %I:%M%p") + end_time.strftime(" - %I:%M%p")
  end
end

class Netflix < MovieCollection
  attr_reader :account

  def initialize(filename)
    super(filename)
    @account = 0
  end

  def show(**attrs_hash)
    filtered = filter(attrs_hash)
    filtered.each { |film|
      take_payment(film)
      puts film
    }
  end

  def pay(amount)
    @account += amount
  end

  def get_price(period)
    payment = {ancient: 1, classic: 1.5, modern: 3, new: 5}
    payment.fetch(period)
  end

  def take_payment(movie)
    if @account < 1
      raise ArgumentError, "You have no money on your account"
    end

    price = get_price(movie.period)
    new_account = @account - price
    if new_account < 0
      raise ArgumentError, "Need more money. Film cost #{price}, you have #{@account} on your account"
    end
    @account = new_account
  end

  def how_much?(movie_title)
    movie = filter(title: movie_title).first
    get_price(movie.period)
  end
end

class Theatre < MovieCollection

end