require_relative 'movie_collection'
require_relative 'cashbox'
require 'money'

module Cinema
  class Netflix < MovieCollection
    extend Cashbox
    attr_reader :user_balance, :user_filters
    PRICES = {
      ancient: Money.new(100, 'USD'),
      classic: Money.new(150, 'USD'),
      modern: Money.new(300, 'USD'),
      new: Money.new(500, 'USD')
    }.freeze
    MOVIE_ATTRS = [:link, :title, :year, :country, :date, :genre, :length, :rating, :director, :actors]

    def initialize(filename)
      super
      @user_balance = Money.new(0, 'USD')
      @user_filters = {}
    end

    def pay(amount)
      amount_cents = amount * 100
      self.class.put_money(amount_cents)
      @user_balance += Money.new(amount_cents, 'USD')
    end

    def show(**filters, &block)
      movies = block ? @collection.select(&block) : filter(filters)
      film = most_popular_movie(movies)
      take_payment(film)
      super(film)
    end

    def define_filter(filter_name, &block)
      raise ArgumentError, 'Empty filter name' if filter_name.nil?
      raise ArgumentError, 'Empty block body' if block.nil?
      @user_filters[filter_name] = block
    end

    def filter(**filters)
      selected_user_filters, other_filters = filters.partition { |k, v| @user_filters.include?(k) }
        .map(&:to_h)
      attr_filters = other_filters.select { |k, v| MOVIE_ATTRS.include?(k) }
      user_filter(selected_user_filters, super(attr_filters))
    end

    def user_filter(filters, collection = @collection)
      filtered = filters.reduce(collection) do |memo, (key, value)|
        memo.select(&@user_filters.fetch(key))
      end
      filtered
    end

    def price(period)
      PRICES.fetch(period)
    end

    def take_payment(movie)
      if @user_balance < Money.new(1, 'USD')
        raise ArgumentError, 'You have no money on your balance'
      end

      new_balance = @user_balance - price(movie.period)
      if new_balance < 0
        raise ArgumentError, "Need more money. Film cost #{price(movie.period)}, you have #{@user_balance} on your balance"
      end
      @user_balance = new_balance
    end

    def how_much?(movie_title)
      movie = filter(title: movie_title).first
      raise ArgumentError, "Movie '#{movie_title}' not found" if movie.nil?
      price(movie.period)
    end
  end
end
