begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

Spec::Runner.configure do |config|
  config.mock_with :rr
end

unless defined? ActiveSupport
  # Ergh, we need to load active_support <3 specifically.. (teehee, <3)
  gem 'activesupport', '<3', :lib => 'active_support'
end

require File.join(File.dirname(__FILE__), '..', 'lib', 'subdomainr')

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }
