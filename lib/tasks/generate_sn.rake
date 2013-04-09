# encoding : utf-8

namespace :sn do
  desc '批量创建序列号'
  task :creation, [:map_id, :type, :map_num, :order, :limit] => :environment do |t, args|
    args.with_defaults limit: 100, type: 0
    puts "============================"
    puts "========开始查找地图：========"
    
    @map = Map.find_by_id args.map_id
    if @map.blank?
      puts "========地图未找到========"
    else
      puts "========开始创建序列号========"
      1.upto(args.limit.to_i) do |i|
        @map.create_single_sn args.type.to_i, args.map_num.to_i, args.order.to_i
        print " #{i} "
        print "\n" if i == args.limit.to_i
      end
      puts "========序列号创建结束========"
    end
  end
end