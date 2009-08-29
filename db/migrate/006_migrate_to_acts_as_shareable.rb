class MigrateToActsAsShareable < ActiveRecord::Migration

  def self.up
    add_column :shares, :status, :integer, :default => 1
    
    Share.destroy_all
    current_sharings = ActiveRecord::Base.connection.execute("select * from group_sharings")
    current_sharings.each do |r|
      share = Share.create(:id => r["id"], 
                           :user_id => r["shared_by"], :status => r["status"],
                           :shareable_type => r["shareable_type"], :shareable_id => r["shareable_id"],
                           :shared_to_type => "Group", :shared_to_id => r["group_id"],
                           :created_at => r["created_at"], :updated_at => r["updated_at"])
    end

    drop_table :group_sharings
  end

  def self.down
    remove_column :shares, :status
    create_table :group_sharings do |t|
      t.integer  :group_id
      t.integer  :shareable_id
      t.string   :shareable_type
      t.integer  :shared_by
      t.integer  :status, :default => 1
      t.timestamps
    end
  end

end
