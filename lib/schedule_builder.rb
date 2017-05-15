require_relative 'custom_schedule'
require_relative 'period'

module Cinema
  class ScheduleBuilder
    def initialize(&block)
      @halls = []
      @periods = []
      instance_eval(&block) # на себе, а не на Custom
      @schedule = CustomSchedule.new(halls: @halls, periods: @periods)
    end

    def hall(slug, title:, places:)
      @halls[slug] << Cinema::Hall.new(slug, title, places)
    end

    def period(time, &block)
      slug = time.first.to_i..time.last.to_i
      @periods[slug] << Cinema::Period.new(slug, &block)
    end
  end
end
