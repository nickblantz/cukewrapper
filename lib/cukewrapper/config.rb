module Cukewrapper
  class Config
    @@tag_pattern = /^@(?<path>ten(?:\.[a-zA-Z]+)+)(?:=(?<value>.*))?$/
  
    attr_reader :scenario_id, :metadata, :inline_remaps
  
    def initialize(scenario)
      @scenario_id = scenario.id
      @metadata = scenario_metadata(scenario)
      @inline_remaps = []
    end
  
    def step_data_handler(*args)
      if args.size > 0
        @inline_remaps += args[0].raw[1..]
          .map { |arr| { path: arr[0], value: arr[1] } }
      end
    end
  
    def as_json(options={})
      {
        scenario_id: @scenario_id,
        metadata: @metadata,
        inline_remaps: @inline_remaps,
      }
    end
  
    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  
    private
  
    def scenario_metadata(scenario)
      metadata = {}
      scenario.tags
        .map(&get_tag_match())
        .each(&set_metadata!(metadata))
      metadata
    end
  
    def get_tag_match
      lambda do |tag|
        if matches = @@tag_pattern.match(tag.name)
          matches.named_captures
        else
          nil
        end
      end
    end
  
    def set_metadata!(hash)
      lambda do |data|
        return if data.nil?
        cur_hash = hash
        idents = data['path'].split('.')[1..]
        idents.each_with_index do |ident, i|
          if i == idents.size - 1
            cur_hash[ident] = data['value'] || true
          else
            cur_hash[ident] = {} unless cur_hash.key?(ident)
            cur_hash = cur_hash[ident]
          end
        end
      end
    end
  end
end