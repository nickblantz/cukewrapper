# frozen_string_literal: true

# Wraps your gherkin!
module Cukewrapper
  require 'yaml'

  CONFIG_FILE = 'cukewrapper.yml'
  LOG_FILE = 'cukewrapper.log'
  CONFIG = File.file?(CONFIG_FILE) ? YAML.load_file(CONFIG_FILE) : raise("Could not find #{CONFIG_FILE}")
end
