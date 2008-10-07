class CreateTogSocialTables < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer  :user_id
      t.string   :first_name
      t.string   :last_name
      t.string   :website
      t.string   :blog
      t.string   :icon
      t.timestamps
    end
    User.find(:all).each{|u|
      profile = Profile.new
      profile.user = u
      profile.save!
    }

    create_table :groups do |t|
      t.string   :name
      t.string   :description
      t.string   :image
      t.string   :state
      t.boolean  :private
      t.boolean  :moderated, :default => false
      t.integer  :user_id
      t.string   :activation_code, :limit => 40
      t.datetime :activated_at
      t.timestamps
    end

    create_table :memberships do |t|
      t.integer  :user_id
      t.integer  :group_id
      t.boolean  :moderator, :default => false
      t.string   :state
      t.string   :activation_code, :limit => 40
      t.datetime :activated_at
      t.timestamps
    end

    create_table :friendships do |t|
      t.integer  :inviter_id
      t.integer  :invited_id
      t.integer  :status
      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
    drop_table :memberships
    drop_table :groups
    drop_table :profiles
  end
end
