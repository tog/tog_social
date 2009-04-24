require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  context "A User" do
    should_have_one  :profile
    should_have_many :memberships
    should_have_many :plain_memberships
    should_have_many :moderator_memberships
    should_have_many :groups
    should_have_many :moderated_groups
    should_have_many :client_applications
    should_have_many :tokens

    context "when destroyed" do
      setup do
        user = Factory(:user)
        group = Factory(:group)
        group.join(user)
        @membership = group.membership_of(user)
        user.destroy
      end

      should "have his group memberships destroyed, too" do
        assert_nil Membership.find_by_id(@membership.id)
      end

    end

  end
end
