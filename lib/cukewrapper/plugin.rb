# frozen_string_literal: true

module Cukewrapper
  # The most based of plugins
  class Plugin
    unless const_defined?(:PRIORITIES)
      PRIORITIES = {
        lowest: -100,
        low: -10,
        normal: 0,
        high: 10,
        highest: 100
      }.freeze
    end

    def <=>(other)
      self.class <=> other.class
    end

    def self.priority(priority = nil)
      @priority ||= nil
      @priority = priority if priority && PRIORITIES.key?(priority)
      @priority || :normal
    end

    def self.<=>(other)
      PRIORITIES[other.priority] <=> PRIORITIES[priority]
    end

    def self.inherited(const)
      super(const)
      catch_inheritance(const) do |const_|
        catch_inheritance(const_)
      end
    end

    def self.catch_inheritance(const)
      const.define_singleton_method :inherited do |const_|
        (@children ||= Set.new).add const_
        yield const_ if block_given?
      end
    end

    def self.descendants
      @children ||= Set.new
      out = @children.map(&:descendants)
      out << self unless superclass == Plugin
      Set.new(out).flatten
    end

    def initialize(config = {})
      @config = config
      register_hooks
    end

    def run(_context); end

    def register_hooks; end
  end
end
