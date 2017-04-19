require_relative 'movie_collection'
require_relative 'cashbox'

class Netflix < MovieCollection
  include Cashbox
  @@account = 0
  PRICES = {ancient: 1, classic: 1.5, modern: 3, new: 5}

   def self.cash
     @@account
   end

   def self.pay(amount)
      raise ArgumentError, "Amount should be positive, #{amount} passed" if amount < 0
      @@account += amount
    end

  def show(**attrs_hash)
    film = most_popular_movie(filter(attrs_hash))
    take_payment(film)
    super(film)
  end

  def get_price(period)
    PRICES.fetch(period)
  end

  def take_payment(movie)
    raise ArgumentError, "You have no money on your account" if @@account < 1

    price = get_price(movie.period)
    new_account = @@account - price
    if new_account < 0
      raise ArgumentError, "Need more money. Film cost #{price}, you have #{@account} on your account"
    end
    @@account = new_account
  end

  def how_much?(movie_title)
    movie = filter(title: movie_title).first
    raise ArgumentError, "Movie '#{movie_title}' not found" if movie.nil?
    get_price(movie.period)
  end
end
