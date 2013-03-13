# encoding : utf-8

require File.expand_path('lib/serials/generator.rb', Rails.root)

namespace :tripmap do
  desc "生成序列号"
  task :generate_serial_code => :environment do
    map = Map.first
    free_type, sale_type = 0, 1
    options = { :map_id => map.id, :type => 1 }
    
    code = MapSerialGenerator.generate_one_serial options
    puts code
    entity = {:map_id => map.id, :code => code, :count => 5, :type => 1}
    MapSerialNumber.create entity
    
  end

end