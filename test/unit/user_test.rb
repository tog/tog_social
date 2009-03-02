require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  context "A User" do
    should_have_one  :profile
    should_have_many :memberships
    should_have_many :plain_memberships
    should_have_many :moderator_memberships
    should_have_many :groups
    should_have_many :moderated_groups
    should_have_many :client_applications
    should_have_many :tokens
  end
end