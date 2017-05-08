require_relative 'schedule'
require_relative 'custom_schedule'

module Cinema
  class ScheduleBuilder
    def self.build(&block)
      block_given? ? CustomSchedule.new(&block) : Schedule.new
    end
  end
end
