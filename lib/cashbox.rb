require 'date'

module Cashbox

    def cash
      @money ||= 0
    end

    def put_money(amount)
      raise ArgumentError, "Amount should be positive, #{amount} passed" if amount < 0
      @money ||= 0
      @money += amount
    end

    def take(who)
      raise ArgumentError, "We call the police!" if who != 'Bank'
      puts 'Encashment was carried out'
      @money = 0
    end
end
