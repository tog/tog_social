ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require 'test_help'
require 'test/unit'
require 'mocha'

begin
  gem 'thoughtbot-shoulda', '>=2.10.1'
  require 'shoulda' 
rescue Exception => e
  puts "\n\nYou need shoulda 2.10.1 or greater to test tog_core. Visit http://github.com/thoughtbot/shoulda to view details.\n\n" 
  exit
end

require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '/factories')

begin require 'redgreen'; rescue LoadError; end

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  def assert_difference(object, method = nil, difference = 1)
    initial_value = object.send(method)
    yield
    assert_equal initial_value + difference, object.send(method), "#{object}##{method} should have a difference of #{difference}"
  end

  def assert_no_difference(object, method, &block)
    assert_difference object, method, 0, &block
  end
  
end
