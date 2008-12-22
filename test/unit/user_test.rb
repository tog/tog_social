require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  context "A User" do
    should_have_many :activities
  end
end