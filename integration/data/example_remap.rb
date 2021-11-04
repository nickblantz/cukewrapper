# frozen_string_literal: true

# Example remapping file
# Must define a function data_remap(hash)

def data_remap(hash)
  hash['foo'] = 'bar'
  hash['lol'] = 'lol'
  hash
end
