require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < Test::Unit::TestCase
  context "A Profile " do
    setup do
      @user = Factory(:user, :login => 'chavez')  
      @user2 = Factory(:user, :login => 'evo')  

      @chavez = Factory(:profile, :first_name => 'Hugo', :last_name => 'Chavez', :user => @user)
      @evo = Factory(:profile, :first_name => 'Evo', :last_name => 'Morales', :user => @user2)
    end
    
    should "returna full_name correctly base on first_name and last_name" do
      assert_equal "Hugo Chavez", @chavez.full_name,  "Full name should Hugo Chavez"
    end  
    
    should "return last_name as full_name if first_name is blank" do
      [nil, ""].each {|value|
        @chavez.first_name = value
        assert_equal "Chavez", @chavez.full_name,  "Full name should Chavez if first name is blank"
      }
    end
    should "return login as full_name if first name and last name are blank" do
      [nil, ""].each {|value|
        @chavez.first_name = @chavez.last_name = value
        assert_equal "chavez",  @chavez.full_name, "full_name should defaults to login if first name and last name are blank"
      }      
    end
    
    should "allow to add a follower" do
      @chavez.add_follower(@evo)
      assert @evo.follows?(@chavez), "Evo should follow Chavez"
      assert @chavez.followed_by?(@evo), "Chavez should be followed by Evo"
    end

    should "allow to add a follower twice with no side effects" do
      assert_difference(Friendship, :count) do
        @chavez.add_follower(@evo)
      end
      assert_no_difference(Friendship, :count) do
        @chavez.add_follower(@evo)
      end
    end
    should "treat add_follower and add_following as symmetrical relationships" do
      @evo.add_following(@chavez)
      assert @evo.follows?(@chavez), "Evo should follow Chavez"
      assert @chavez.followed_by?(@evo), "Chavez should be followed by Evo"
    end
    
    should "convert a mutual follower relationship between 2 users on a friendship" do
      @chavez.add_follower(@evo)
      @evo.add_follower(@chavez)
      assert @evo.is_friend_of?(@chavez)
      assert @chavez.is_friend_of?(@evo)
    end
    should "allow to add a friend" do
      assert !@evo.is_related_to?(@chavez)
      assert @evo.add_friend(@chavez)
      assert @evo.is_friend_of?(@chavez), "Evo and Chavez should be friends"
      assert @chavez.is_friend_of?(@evo), "Chavez and Evo should be friends"
    end
    should "allow to remove a friend" do
      assert @evo.add_friend(@chavez)
      assert @evo.is_friend_of?(@chavez), "Evo and Chavez should be friends"
      @evo.remove_friend(@chavez)
      assert !@evo.is_friend_of?(@chavez)
      assert !@evo.is_related_to?(@chavez)
    end
    should "allow to remove a follower" do
      @chavez.add_follower(@evo)
      assert @chavez.is_related_to?(@evo)
      @chavez.remove_follower(@evo)
      assert !@evo.follows?(@chavez), "Evo should not follow Chavez anymore"
      assert !@chavez.followed_by?(@evo), "Chavez should not be followed by Evo anymore"
    end
    should "allow to remove a following" do
      @evo.add_following(@chavez)
      assert @evo.is_related_to?(@chavez)
      @evo.remove_following(@chavez)
      assert !@evo.follows?(@chavez), "Evo should not follow Chavez anymore"
      assert !@chavez.followed_by?(@evo), "Chavez should not be followed by Evo anymore"
    end
  end
end