# encoding : utf-8

namespace :offline_package do

  include TripMapOfflinePackage

  desc 'Offline Package'
  task :migrate => :environment do
    entity = Scenic.first
    pkg = OfflinePackage.new entity
    pkg.create_package

  end

end