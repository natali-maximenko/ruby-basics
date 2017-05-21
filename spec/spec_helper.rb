require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr'
  # your HTTP request service.
  c.hook_into :webmock
end

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  # Add VCR to all tests
  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}
    name = example.metadata[:full_description].split(/\s+/, 2).join('/').downcase.gsub(/\./,'/').gsub(/[^\w\/]+/, '_').gsub(/\/$/, '')
    VCR.use_cassette(name, options, &example)
  end
end
