require_relative 'movie_collection'
require_relative 'cashbox'
require 'money'

module Cinema
  class Netflix < MovieCollection
    extend Cashbox
    attr_reader :user_balance
    PRICES = {
      ancient: Money.new(100, 'USD'),
      classic: Money.new(150, 'USD'),
      modern: Money.new(300, 'USD'),
      new: Money.new(500, 'USD')
    }.freeze

    def initialize(filename)
      super
      @user_balance = Money.new(0, 'USD')
    end

    def pay(amount)
      amount_cents = amount * 100
      self.class.put_money(amount_cents)
      @user_balance += Money.new(amount_cents, 'USD')
    end

    def show(attrs_hash = {})
      if block_given?
        movies = @collection.select { |movie| yield movie }
        film = most_popular_movie(movies)
      else
        film = most_popular_movie(filter(attrs_hash))
      end
      take_payment(film)
      super(film)
    end

    def get_price(period)
      PRICES.fetch(period)
    end

    def take_payment(movie)
      if @user_balance < Money.new(1, 'USD')
        raise ArgumentError, 'You have no money on your balance'
      end

      price = get_price(movie.period)
      new_balance = @user_balance - price
      if new_balance < 0
        raise ArgumentError, "Need more money. Film cost #{price}, you have #{@user_balance} on your balance"
      end
      @user_balance = new_balance
    end

    def how_much?(movie_title)
      movie = filter(title: movie_title).first
      raise ArgumentError, "Movie '#{movie_title}' not found" if movie.nil?
      get_price(movie.period)
    end
  end
end
