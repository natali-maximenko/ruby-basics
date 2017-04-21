require 'money'
module Cinema
  # Cashbox module
  module Cashbox
    I18n.enforce_available_locales = false

    def cash
      @money ||= Money.new(0, 'USD')
    end

    def put_money(amount)
      if amount < 0
        raise ArgumentError, "Amount should be positive, #{amount} passed"
      end
      @money = cash + Money.new(amount, 'USD')
    end

    def take(who)
      raise ArgumentError, 'We call the police!' if who != 'Bank'
      puts 'Encashment was carried out'
      @money = Money.new(0, 'USD')
    end
  end
end
