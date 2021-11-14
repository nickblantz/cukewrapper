# frozen_string_literal: true

# Mock Cukewrapper
module Cukewrapper
  require 'logger'

  CONFIG = { 'foo' => 'bar' }.freeze
  LOGGER = Logger.new(nil)
end
