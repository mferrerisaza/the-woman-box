require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "#{Rails.root}/spec/cassetes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
  config.default_cassette_options = { re_record_interval: 1.day }
  config.filter_sensitive_data('<surprise1>') { ENV['EPAYCO_PUBLIC_KEY'] }
  config.filter_sensitive_data('<surprise2>') { ENV['EPAYCO_PRIVATE_KEY'] }
end
