# frozen_string_literal: true

require 'cukewrapper/metatags'

module Mock
  # Mock Cucumber Tag
  class MockTag
    attr_accessor :name

    def initialize(tag)
      @name = tag
    end
  end
end

RSpec.describe Cukewrapper::Metatags do
  it 'succeeds when no tags are present' do
    metatags = Cukewrapper::Metatags.build([])
    expect(metatags.to_hash).to eq({})
  end

  it 'ignores incorrectly formatted tags' do
    metatags = Cukewrapper::Metatags.build([
      Mock::MockTag.new('@wrong.a.b'),
      Mock::MockTag.new('@cw'),
      Mock::MockTag.new('@cw.'),
      Mock::MockTag.new('@cw.0'),
      Mock::MockTag.new('@cw._'),
      Mock::MockTag.new('@cw.-'),
      Mock::MockTag.new('@cw.a.')
    ])
    expect(metatags.to_hash).to eq({})
  end

  context 'when valid tags are present' do
    metatags = Cukewrapper::Metatags.build([
      Mock::MockTag.new('@cw.mock.managed'),
      Mock::MockTag.new('@cw.mock.tid=000000'),
      Mock::MockTag.new('@cw.data.source=./data/example.json')
    ])

    it 'parses them correctly' do
      expect(metatags.to_hash).to eq({
        'mock' => {
          'managed' => true,
          'tid' => '000000'
        },
        'data' => {
          'source' => './data/example.json'
        }
      })
    end

    it 'accesses keys correctly' do
      expect(metatags['data']).to eq({
        'source' => './data/example.json'
      })
    end
  end
end
