# Example remapping file
# Must define a function remap(hash)

def remap(hash)
  hash['foo'] = 'bar'
  hash['lol'] = 'lol'
  return hash
end