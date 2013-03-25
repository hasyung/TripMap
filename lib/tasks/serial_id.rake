# encoding: utf-8

require File.expand_path('lib/serials/generator.rb', Rails.root)

  desc "批量生成序列号入库"
  #map_id：地图id，type：序列号类型, count：生成数量， split：序列号格式是否需要-号
  #eg:  rake serial_id_generator[__,__,__,__]
  #     rake serial_id_generator[1,0,1,true]
  task :serial_id_generator, [:map_id, :type, :count, :split] => :environment do |t, args|
    args.with_defaults(:count => 0)

    use_count = case args[:type].to_i
                     when 0    then 1
                     when 1..2 then 5
                     else        0
                    end

    map_id, serial_type, serial_split = args[:map_id].to_i, args[:type].to_i, args[:split]=="true"

    puts "------Generate start!------"
    args[:count].to_i.times do |c|
      serial_id = MapSerialGenerator.generate_one_serial map_id: map_id,
                                                         type:   serial_type,
                                                         split:  serial_split
      MapSerialNumber.create map_id: map_id, 
                             code: serial_id, 
                             count: use_count, 
                             type_cd: serial_type,
                             printed_cd: 0
      puts "Generate: #{c+1}"
    end
    puts "------Generate end!------"
  end