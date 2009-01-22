class AddAttachmentsImageToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :image_file_name, :string
    add_column :groups, :image_content_type, :string
    add_column :groups, :image_file_size, :integer
    add_column :groups, :image_updated_at, :datetime

    rename_column :groups, :image, :old_file_name

    add_crop("plugins.tog_social.group.image.versions.big")
    add_crop("plugins.tog_social.group.image.versions.medium")
    add_crop("plugins.tog_social.group.image.versions.small")
    add_crop("plugins.tog_social.group.image.versions.tiny")

    Group.all.each do |p|
      unless p.old_file_name.blank?
        p.image = File.new("public/system/group_photos/group/image/#{p.id}/#{p.old_file_name}") if File.exists?("public/system/group_photos/group/image/#{p.id}/#{p.old_file_name}")
        p.save!
      end
    end
    FileUtils.rm_rf "public/system/group_photos/"

    remove_column :groups, :old_file_name
  end

  def self.down
    add_column :groups, :image, :string

    remove_crop("plugins.tog_social.group.image.versions.big")
    remove_crop("plugins.tog_social.group.image.versions.medium")
    remove_crop("plugins.tog_social.group.image.versions.small")
    remove_crop("plugins.tog_social.group.image.versions.tiny")

    Group.all.each do |p|
      unless p.image_file_name.blank?
        p.image = File.new("public/system/groups/images/#{p.id}/#{p.image_file_name}") if File.exists?("public/system/groups/images/#{p.id}/#{p.image_file_name}")
        p.save!
      end
    end
    FileUtils.rm_rf "public/system/groups"

    remove_column :groups, :image_file_name
    remove_column :groups, :image_content_type
    remove_column :groups, :image_file_size
    remove_column :groups, :image_updated_at
  end

  private
  def self.add_crop(key)
    Tog::Config[key]="#{Tog::Config[key]}#" unless Tog::Config[key] =~ /#|%|@|!|<|>|\^/
  end

  def self.remove_crop(key)
    Tog::Config[key]=Tog::Config[key].gsub("#",'')
  end
end
