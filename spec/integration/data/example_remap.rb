# frozen_string_literal: true

# Example remapping file
# Must define a function remap(hash)

def remap(hash)
  hash['foo'] = 'bar'
  hash['lol'] = 'lol'
  hash
end
