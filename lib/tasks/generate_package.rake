# encoding : utf-8
require "offline_package/trip_map_offline_package"

namespace :offline_package do

  include TripMapOfflinePackage

  desc 'Create Offline Package'
  task :create_pkg => :environment do
    t_start = Time.now
    Scenic.all.each do|e|
      OfflinePackage.create_package e
      update_keyword_version e
    end
    t_end_s = Time.now
    puts "All Scenics packaged time span: %s(s)"%(t_end_s - t_start).to_s

    Place.all.each do|e|
      OfflinePackage.create_package e
      update_keyword_version e
    end
    t_end_p = Time.now
    puts "All Places packaged time span:  %s(s)"%(t_end_p - t_end_s).to_s
  end

  def update_keyword_version( model )
    model_slug = "%s_slug"%model.class.name.downcase
    keyword = model.send(model_slug)
    keyword.version = Time.now.to_i
    keyword.save
  end

end