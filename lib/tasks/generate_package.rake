# encoding : utf-8
require "offline_package/trip_map_offline_package"

namespace :offline_package do

  include TripMapOfflinePackage

  desc 'Offline Package'
  task :create_pkg => :environment do
    entity = Scenic.first
    OfflinePackage.create_package entity
  end

end