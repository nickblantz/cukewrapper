# frozen_string_literal: true

require 'cukewrapper/plugin'
require 'cukewrapper/remapper'
require 'cukewrapper/executor'
require 'cukewrapper/validator'

module Mock
  class RemapperLowest < Cukewrapper::Remapper; priority :lowest; end

  class RemapperLow < Cukewrapper::Remapper; priority :low; end

  class RemapperNormal < Cukewrapper::Remapper; priority :normal; end

  class RemapperHigh < Cukewrapper::Remapper; priority :high; end

  class RemapperHighest < Cukewrapper::Remapper; priority :highest; end

  class Executor < Cukewrapper::Executor; end

  class Validator < Cukewrapper::Validator; end
end

RSpec.describe Cukewrapper::Plugin do
  it 'are sorted by priority' do
    expect(Cukewrapper::Remapper.descendants.sort).to eq([
      Mock::RemapperHighest,
      Mock::RemapperHigh,
      Mock::RemapperNormal,
      Mock::RemapperLow,
      Mock::RemapperLowest
    ])
  end
end
