# frozen_string_literal: true

module Cukewrapper
  # Super meta bro
  class Metatags
    TAG_PATTERN = /^@(?<path>ten(?:\.[a-zA-Z]+)+)(?:=(?<value>.*))?$/.freeze

    def initialize(tags)
      @internal = {}
      build_hash!(@internal, tags)
      LOGGER.debug("#{self.class.name}\##{__method__}") { @internal.inspect }
    end

    def [](key)
      return nil unless @internal.key?(key)

      @internal[key]
    end

    def to_hash
      @internal
    end

    def to_json(*options)
      to_hash.to_json(*options)
    end

    private

    def build_hash!(cur_hash, tags)
      tags.map(&to_captures).each(&build!(cur_hash))
    end

    def build!(cur_hash)
      lambda do |data|
        return if data.nil?

        new_value = data['value'] || true
        idents = data['path'].split('.')[1..]
        idents.each_with_index(&set_value!(cur_hash, idents.size, new_value))
      end
    end

    def set_value!(cur_hash, idents_size, new_value)
      lambda do |ident, index|
        if index == idents_size - 1
          cur_hash[ident] = new_value
        else
          cur_hash[ident] = {} unless cur_hash.key?(ident)
          cur_hash = cur_hash[ident]
        end
      end
    end

    def to_captures
      lambda do |tag|
        if (matches = TAG_PATTERN.match(tag.name))
          matches.named_captures
        end
      end
    end
  end
end
