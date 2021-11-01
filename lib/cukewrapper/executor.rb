# frozen_string_literal: true

# Wraps your gherkin!
module Cukewrapper
  require 'faker'
  require 'json'
  require 'jsonpath'

  # Executes the test and sets the result
  class Executor
    def initialize(config)
      @config = config
      @data = {}
    end

    def exec
      test_failed = false
      load_data!
      begin
        write_report
      rescue StandardError => e
        test_failed = true
      ensure
        set_result(test_failed, e)
      end
    end

    def to_hash
      {
        config: @config.to_hash,
        data: @data
      }
    end

    def to_json(*options)
      to_hash.to_json(*options)
    end

    private

    def write_report
      File.open("reports/#{@config.scenario_id}.json", 'w') do |file|
        file.write(JSON.pretty_generate(self))
      end
    end

    def set_result(test_failed, exception)
      raise 'Scenario tagged to fail' if fail?
      raise 'Scenario tagged to negate' if negate_success?(test_failed)
      return if negate_failure?(test_failed)
      raise exception if test_failed
    end

    def fail?
      @config.metadata['fail']
    end

    def negate_success?(test_failed)
      !test_failed && @config.metadata['negate']
    end

    def negate_failure?(test_failed)
      test_failed && (@config.metadata['negate'] || @config.metadata['succeed'])
    end

    def succeed?
      @config.metadata['fail']
    end

    def load_data!
      metadata = @config.metadata
      if metadata.key?('data') && metadata['data'].key?('source')
        @data = JSON.parse(File.read(metadata['data']['source']))
      end
      external_remap!
      inline_remap!
    end

    def external_remap!
      metadata = @config.metadata
      return unless metadata.key?('data') && metadata['data'].key?('remap')

      load metadata['data']['remap']
      @data = remap(@data)
    end

    def inline_remap!
      @config.inline_remaps.each do |remap|
        JsonPath
          .for(@data)
          .gsub!(remap[:path], &value_remapper(remap[:value]))
      end
    end

    def value_remapper(raw)
      lambda do |value|
        prefix = raw[0]
        if prefix == '~'
          remapper_merge(value, raw[1..])
        else
          eval_or_parse(raw)
        end
      end
    end

    def remapper_merge(value, raw)
      return value if raw == ''

      parsed = eval_or_parse(raw)

      case parsed
      when Array
        value + parsed
      when Hash
        parsed.each { |k, v| value[k] = v }
        value
      else
        parsed
      end
    end

    def eval_or_parse(raw)
      prefix = raw[0]
      if prefix == '#'
        # rubocop:disable Security/Eval
        eval raw[1..]
        # rubocop:enable Security/Eval
      else
        return nil if raw == ''

        JSON.parse(raw)
      end
    end
  end
end
