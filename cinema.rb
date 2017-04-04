require './movie.rb'
require './movie_collection.rb'
require 'date'

class Cinema
  attr_accessor :movies

  def initialize(movie_collection)
    @movies = movie_collection
  end

  def show(movie)
    start_time = Time.now
    end_time = start_time + 60 * movie.length.to_i
    p "Now showing: #{movie.title}" + start_time.strftime(" %I:%M%p") + end_time.strftime(" - %I:%M%p")
  end

end

class Netflix < Cinema
   attr_accessor :account

   def initialize(movie_collection)
     super(movie_collection)
     @account = 0
   end

   def show(**attrs_hash)
     filtered = @movies.filter(attrs_hash)
     filtered.each { |film|
       self.take_payment(film)
       p film
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
     price = self.get_price(movie.period)
     new_account = @account - price
     if new_account < 0
       raise ArgumentError, "Need more money. Film cost #{price}, you have #{@account} on your account"
     end
     @account = new_account
   end

   def how_much?(movie_title)
     movie = @movies.filter(title: movie_title).first
     self.get_price(movie.period)
   end
end

class Theatre < Cinema

end