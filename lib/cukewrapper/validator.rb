# frozen_string_literal: true

# Wraps your gherkin!
module Cukewrapper
  require 'cukewrapper/plugin'

  # Ensuring success
  Validator = Class.new(Cukewrapper::Plugin)
end
