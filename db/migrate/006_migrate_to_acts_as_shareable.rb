class MigrateToActsAsShareable < ActiveRecord::Migration

  def self.up
    add_column :shares, :status, :integer, :default => 1
    
    Share.destroy_all
    current_sharings = ActiveRecord::Base.connection.execute("select * from group_sharings")
    current_sharings.each do |r|
      share = Share.create(:id => r[0], 
                           :user_id => r[4], :status => r[5],
                           :shareable_type => r[3], :shareable_id => r[2],
                           :shared_to_type => "Group", :shared_to_id => r[1],
                           :created_at => r[6], :updated_at => r[7])
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
