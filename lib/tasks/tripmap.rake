# encoding : utf-8

require File.expand_path('lib/serials/generator.rb', Rails.root)

namespace :tripmap do
  
  desc "生成一个序列号并入库"
  task :generate_serial_code => :environment do
    map = Map.first
    free_type, sale_collection, sale_general = 0, 1, 2#:free, :ordinary, :favorite
    options = { :map_id => map.id, :split => true }
        
    t_begin = Time.now
    puts t_begin
    code_free = MapSerialGenerator.generate_one_serial options.merge({:type => free_type})
    
    code_sale_collection = MapSerialGenerator.generate_one_serial options.merge({:type => sale_collection})
    code_sale_general = MapSerialGenerator.generate_one_serial options.merge({:type => sale_general})
    t_end = Time.now
    puts t_end
    puts "Generate one serial time span: " + (t_end - t_begin).to_s
    puts code_free + "\n" + code_sale_collection + "\n" + code_sale_general
    
    entity_free = { :map_id => map.id, :code => code_free, :count => 1, :type_cd => free_type, :printed_cd => 0 }
    entity_sale_collection = { :map_id => map.id, :code => code_sale_collection, :count => 5, :type_cd => sale_collection, :printed_cd => 0 }
    entity_sale_general = { :map_id => map.id, :code => code_sale_general, :count => 5, :type_cd => sale_general, :printed_cd => 0 }
    
    MapSerialNumber.create entity_free
    MapSerialNumber.create entity_sale_collection
    MapSerialNumber.create entity_sale_general
    
  end

end