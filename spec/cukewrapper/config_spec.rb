# frozen_string_literal: true

require 'cukewrapper/config'

RSpec.describe Cukewrapper::Config do
  before(:each) do 
    ENV.clear
  end 

  it 'creates an empty config if file not found' do
    config = Cukewrapper::Config.load_config('spec/data/does_not_exist.yml')
    expect(config).to eq({})
  end

  it 'loads a config file' do
    config = Cukewrapper::Config.load_config('spec/data/cw_config.yml')
    expect(config).to eq({'foo' => 'bar'})
  end

  it 'overrides config values from environment variables' do
    ENV['CW_FOO'] = 'baz'
    config = Cukewrapper::Config.load_config('spec/data/cw_config.yml')
    expect(config).to eq({'foo' => 'baz'})
  end

  it 'creates nested hashes from environment variables' do
    ENV['CW_A_B_C'] = 'abc'
    config = Cukewrapper::Config.load_config('spec/data/does_not_exist.yml')
    expect(config).to eq({'a' => {'b' => {'c' => 'abc'}}})
  end
end