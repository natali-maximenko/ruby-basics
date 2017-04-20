require_relative 'movie_collection'
require_relative 'cashbox'

class Netflix < MovieCollection
  extend Cashbox
  attr_accessor :account
  PRICES = {ancient: 1, classic: 1.5, modern: 3, new: 5}

  def initialize(filename)
    super
    @account = 0
  end

   def pay(amount)
      self.class.put_money(amount)
      @account += amount
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
    raise ArgumentError, "Movie '#{movie_title}' not found" if movie.nil?
    get_price(movie.period)
  end
end
