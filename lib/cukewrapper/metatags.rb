# frozen_string_literal: true

module Cukewrapper
  # Super meta bro
  module Metatags
    TAG_PATTERN = /^@(?<path>ten(?:\.[a-zA-Z]+)+)(?:=(?<value>.*))?$/.freeze

    def self.build(tags)
      result = {}
      tags.map(&to_captures).each(&build!(result))
      LOGGER.debug("Cukewrapper::Metatags\##{__method__}") { result.inspect }
      result
    end

    def self.build!(cur_hash)
      lambda do |data|
        return if data.nil?

        new_value = data['value'] || true
        idents = data['path'].split('.')[1..]
        idents.each_with_index(&set_value!(cur_hash, idents.size, new_value))
      end
    end

    def self.set_value!(cur_hash, idents_size, new_value)
      lambda do |ident, index|
        if index == idents_size - 1
          cur_hash[ident] = new_value
        else
          cur_hash[ident] = {} unless cur_hash.key?(ident)
          cur_hash = cur_hash[ident]
        end
      end
    end

    def self.to_captures
      lambda do |tag|
        if (matches = TAG_PATTERN.match(tag.name))
          matches.named_captures
        end
      end
    end
  end
end
