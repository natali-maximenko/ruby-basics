require 'date'

module Cashbox
    def cash
      @account
    end

    def take(who)
      raise ArgumentError, "We call the police!" if who != 'Bank'
      puts 'Encashment was carried out'
      @account = 0
    end
end

module NetflixCashbox
    def pay(amount)
      raise ArgumentError, "Amount should be positive, #{amount} passed" if amount < 0
      @account += amount
    end
end

module TheatreCashbox
  PRICES = {morning: 3, day: 5, evening: 10}
  PERIODS = {
      morning: 8..11,
      day: 12..17,
      evening: 17..23
  }

  def get_price
    hour = DateTime.now.hour
    daytime = PERIODS.keys.detect { |period| PERIODS[period] === hour }
    PRICES.fetch(daytime)
  end

  def buy_ticket(movie)
    @account += get_price
    puts "You bought a ticket for #{movie.title}"
  end
end
