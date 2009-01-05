class CreateShareWithGroupTables < ActiveRecord::Migration
  def self.up
    create_table :group_sharings do |t|
      t.integer  :group_id
      t.integer  :shareable_id
      t.string   :shareable_type
      t.integer  :shared_by
      t.integer  :status, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :group_sharings
  end
end
