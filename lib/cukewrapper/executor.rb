module Cukewrapper
  require 'faker'
  require 'json'
  require 'jsonpath'

  class Executor
    def initialize(config)
      @config = config
      @data = {}
    end

    def exec()
      is_failure = false
      load_data!()
      external_remap!()
      inline_remap!()
      begin
        File.open("reports/#{@config.scenario_id}.json", 'w') do |file|
          file.write(JSON.pretty_generate(self))
        end
      rescue => exception
        is_failure = true
      ensure
        raise 'Scenario tagged to fail' if @config.metadata['fail']
        raise 'Scenario tagged to negate' if !is_failure && @config.metadata['negate']
        return if is_failure && (@config.metadata['negate'] || @config.metadata['succeed'])
        raise exception if is_failure
      end
    end

    def as_json(options={})
      {
        config: @config.as_json,
        data: @data
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    private

    def load_data!()
      if @config.metadata.key?('data') && @config.metadata['data'].key?('source')
        @data = JSON.parse(File.read(@config.metadata['data']['source']))
      end
    end

    def external_remap!()
      if @config.metadata.key?('data') && @config.metadata['data'].key?('remap')
        load @config.metadata['data']['remap']
        @data = remap(@data)
      end
    end

    def inline_remap!()
      @config.inline_remaps.each do |remap|
        JsonPath
          .for(@data)
          .gsub!(remap[:path], &value_remapper(remap[:value]))
      end
    end

    def value_remapper(raw)
      lambda do |value|
        if raw[0] == '~'
          remapper_merge(value, raw[1..])
        elsif raw[0] == '#'
          eval raw[1..]
        else
          return nil if raw == ''
          JSON.parse(raw)
        end
      end
    end

    def remapper_merge(value, raw)
      return value if raw == ''
      if raw[0] == '#'
        parsed = eval raw[1..]
      else
        parsed = JSON.parse(raw)
      end
      case parsed
      when Array
        value + parsed
      when Hash
        parsed.each do |k, v|
          value[k] = v
        end
        value
      else
        parsed
      end
    end
  end
end