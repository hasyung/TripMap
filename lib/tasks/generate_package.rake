# encoding : utf-8
require "offline_package/trip_map_offline_package"
require 'fileutils'

namespace :offline_package do

  include TripMapOfflinePackage

  PKG_PATH = 'public/uploads/packages'

  desc 'Create Offline Package'
  task :create_pkg => :environment do
    t_start = Time.now
    Scenic.all.each do|e|
      update_keyword_version e
      OfflinePackage.create_package e
    end
    t_end_s = Time.now
    puts "All Scenics packaged time span: %s(s)"%(t_end_s - t_start).to_s

    Place.all.each do|e|
      update_keyword_version e
      OfflinePackage.create_package e
    end
    t_end_p = Time.now
    puts "All Places packaged time span:  %s(s)"%(t_end_p - t_end_s).to_s
  end

  desc 'Remove all expired Offline Packages'
  task :rm_expired_offline_pkgs => :environment do
    puts 'Begin cleaning expired offline packages !'
    versions = Keyword.all.map(&:version).select{|e| e.present? }

    zip_pattern = Rails.root.to_s + "/public/uploads/packages/*.zip"
    zip_files = Dir[zip_pattern]
    zip_files.map!{|e| e = File.basename(e, '.zip') }
    (zip_files - versions).each do|e|
      zip_file_path = "%s/public/uploads/packages/%s.zip"%[Rails.root.to_s, e]
      File.delete(zip_file_path) if File.exist?(zip_file_path)
    end
    puts 'All expired offline packages cleaned!'
  end

  def update_keyword_version( model )
    model_slug = "%s_slug"%model.class.name.downcase
    keyword = model.send(model_slug)
    keyword.version = Time.now.to_i
    keyword.file_size = get_file_size_in_mega(keyword.slug)
    keyword.save
  end

  def get_file_size_in_mega( slug )
    fp = File.join(Rails.root.to_s, PKG_PATH, "%s.zip"%slug)
    fs = (File.size(fp).to_f / 2**20).round(2)
  end

end