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
