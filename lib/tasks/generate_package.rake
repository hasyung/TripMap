# encoding : utf-8
require "offline_package/trip_map_offline_package"

namespace :offline_package do

  include TripMapOfflinePackage

  desc 'Create Offline Package'
  task :create_pkg => :environment do
    scenic = Scenic.first
    place = Place.first
    OfflinePackage.create_package scenic
    OfflinePackage.create_package place
  end

end