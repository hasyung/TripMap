# encoding : utf-8

namespace :keyword do

  desc '迁移slug至keywords数据表'
  task :migrate => :environment do
    puts "========开始执行迁移：========"

    Map.all.each do |map|
      s = map.build_map_slug slug: map.slug
      s.save
    end

     Scenic.all.each do |scenic|
      s= scenic.build_scenic_slug slug: scenic.slug
      s.save
    end

    Place.all.each do |place|
      s= place.build_place_slug slug: place.slug
      s.save
    end

    InfoList.all.each do |info_list|
      s = info_list.build_info_list_slug slug: info_list.slug
      s.save
    end

    Info.all.each do |info|
      s= info.build_info_slug slug: info.slug
      s.save
    end

    Merchant.all.each do |merchant|
      s = merchant.build_merchant_slug slug: merchant.slug
      s.save
    end

    Recommend.all.each do |recommend|
      s = recommend.build_recommend_slug slug: recommend.slug
      s.save
    end
    puts "========迁移结束========"
  end
end