# frozen_string_literal: true

# Wraps your gherkin!
module Cukewrapper
  require 'cukewrapper/plugin'

  # Wrap game strong
  Executor = Class.new(Plugin)
end
