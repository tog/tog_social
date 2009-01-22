class AddAttachmentsIconToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :icon_file_name,    :string
    add_column :profiles, :icon_content_type, :string
    add_column :profiles, :icon_file_size,    :integer
    add_column :profiles, :icon_updated_at,   :datetime

    rename_column :profiles, :icon, :old_file_name

    add_crop("plugins.tog_social.profile.image.versions.big")
    add_crop("plugins.tog_social.profile.image.versions.medium")
    add_crop("plugins.tog_social.profile.image.versions.small")
    add_crop("plugins.tog_social.profile.image.versions.tiny")

    Profile.all.each do |p|
      unless p.old_file_name.blank?
        p.icon = File.new("public/system/profile/profile/icon/#{p.id}/#{p.old_file_name}") if File.exists?("public/system/profile/profile/icon/#{p.id}/#{p.old_file_name}")
        p.save!
      end
    end
    FileUtils.rm_rf "public/system/profile/"

    remove_column :profiles, :old_file_name
  end

  def self.down
    add_column :profiles, :icon, :string

    remove_crop("plugins.tog_social.profile.image.versions.big")
    remove_crop("plugins.tog_social.profile.image.versions.medium")
    remove_crop("plugins.tog_social.profile.image.versions.small")
    remove_crop("plugins.tog_social.profile.image.versions.tiny")

    Profile.all.each do |p|
      unless p.icon_file_name.blank?
        p.icon = File.new("public/system/profiles/images/#{p.id}/#{p.icon_file_name}") if File.exists?("public/system/profiles/images/#{p.id}/#{p.icon_file_name}")
        p.save!
      end
    end
    FileUtils.rm_rf "public/system/profiles"

    remove_column :profiles, :icon_file_name
    remove_column :profiles, :icon_content_type
    remove_column :profiles, :icon_file_size
    remove_column :profiles, :icon_updated_at
  end

  private
  def self.add_crop(key)
    Tog::Config[key]="#{Tog::Config[key]}#" unless Tog::Config[key] =~ /#|%|@|!|<|>|\^/
  end

  def self.remove_crop(key)
    Tog::Config[key]=Tog::Config[key].gsub("#",'')
  end
end
