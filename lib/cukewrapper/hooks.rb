# frozen_string_literal: true

module Cukewrapper
  # Hooking it all together
  module Hooks
    PRIORITIES = {
      lowest: -100,
      low: -10,
      normal: 0,
      high: 10,
      highest: 100
    }.freeze

    DEFAULT_PRIORITY = PRIORITIES[:normal].freeze

    @registry = {
      before_scenario: {},
      after_metatags: {},
      after_datatables: {},
      before_execution: {},
      after_execution: {},
      after_scenario: {}
    }

    @hook_priority = {}

    def self.priority_value(priority)
      return priority if priority.is_a?(Integer)

      PRIORITY_MAP[priority] || DEFAULT_PRIORITY
    end

    def self.register(name, event, priority: DEFAULT_PRIORITY, &block)
      raise 'Hooks must respond to :call' unless block.respond_to? :call

      LOGGER.debug("Cukewrapper::Hooks\##{__method__}") { event }
      priority = priority_value(priority)
      @hook_priority[name] = [-priority, @hook_priority.size]
      @registry[event][name] = block
    end

    def self.trigger(event, *args)
      hooks = @registry[event]
      LOGGER.debug("Cukewrapper::Hooks\##{__method__}") { event }
      return if hooks.nil? || hooks.empty?

      hooks.sort_by { |name, _| @hook_priority[name] }.each do |_, hook|
        hook.call(*args)
      end
    end
  end
end
