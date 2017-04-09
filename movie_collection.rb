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
      Movie.create(movie)
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
  PRICES = {ancient: 1, classic: 1.5, modern: 3, new: 5}

  def initialize(filename)
    super
    @account = 0
  end

  def show(**attrs_hash)
    filtered = filter(attrs_hash)
    film = filtered.first
    take_payment(film)
    puts film
  end

  def pay(amount)
    raise ArgumentError, "Amount should be positive, #{amount} passed" if amount < 0
    @account += amount
  end

  def get_price(period)
    PRICES.fetch(period)
  end

  def take_payment(movie)
    raise ArgumentError, "You have no money on your account" if @account < 1

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