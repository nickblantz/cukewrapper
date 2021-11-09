# frozen_string_literal: true

# Wraps your gherkin!
module Cukewrapper
  require 'yaml'

  CONFIG_FILE = 'cukewrapper.yml'
  LOG_FILE = 'cukewrapper.log'
  CONFIG = YAML.load_file(CONFIG_FILE) if File.file?(CONFIG_FILE)
end
