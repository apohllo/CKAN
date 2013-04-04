require File.expand_path(File.dirname(__FILE__) + '/../lib/ckan')
require 'vcr'
require 'webmock'
include WebMock

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/cassettes'
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end

include CKAN
