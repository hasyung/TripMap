# encoding : utf-8

namespace :device do

  desc '迁移devices数据表，并添加关系'
  task :migrate => :environment do

    puts "========开始执行迁移：========"
    ActivateMap.all.each do |activate|
      d = Device.new device_id: activate.device_id, created_at: activate.created_at
      activate.accounts.each do |a|
        d.map_serial_numbers << a.map_serial_number if a.map_serial_number.present? &&
                                                      d.map_serial_numbers.count = 0
      end
      d.save
    end
    puts "========迁移结束========"
    
  end
end