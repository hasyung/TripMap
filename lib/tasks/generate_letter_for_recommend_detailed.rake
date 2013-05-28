# encoding : utf-8

namespace :letter do

  desc '迁移recommend_detailed_leter'
  task :migrate => :environment do
    puts "========开始执行迁移：========"

    letters  = Letter.where(textable_type: "RecommendDetailed", text_type: 0)
    letters.update_all( text_type: 6 )
    puts "========迁移结束========"
  end
end