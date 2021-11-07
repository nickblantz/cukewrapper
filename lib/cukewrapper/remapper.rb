# frozen_string_literal: true

# Wraps your gherkin!
module Cukewrapper
  require 'cukewrapper/plugin'

  # Clean up game strong
  Remapper = Class.new(Cukewrapper::Plugin)
end
