# encoding: utf-8;

Province.create([
  { name: "云南", slug: "YN" },
  { name: "四川", slug: "SC" } 
])

Map.create([
  { province: Province.first, name: "丽江", slug: "" },
])

Scenic.create([
  { map: Map.first, name: "丽江市", slug: "LJS", },
  { map: Map.first, name: "玉龙雪山", slug: "YLXS" },
])

scenic = Scenic.first
scenic.build_scenic_impression :file => "初始印象", :file_type => "rmvb", :file_size => 10240, :cover => "初始印象封面图", :cover_type => "png", :cover_size => 1024, :order => 1, :duration => 12, :video_type => 0
scenic.save

Place.create([
  { map: Map.first, name: "束河古镇", slug: "SHGZ" },
  { map: Map.first, name: "拉市海", slug: "LSH" },
])

Recommend.create([
  { map: Map.first, name: "吃美味", slug: "CMW" },
  { map: Map.first, name: "住客栈", slug: "ZKZ" },
  { map: Map.first, name: "带回家", slug: "DHJ" }, 
])

RecommendRecord.create([
  { recommend: Recommend.first, name: "丽江小吃" },
  { recommend: Recommend.first, name: "地道菜"   },
  { recommend: Recommend.first, name: "外地菜"   },
  { recommend: Recommend.first, name: "美食街"   }, 
])