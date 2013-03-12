# encoding: utf-8;
yn = Province.new name: "云南", slug: "yn"

lj = yn.maps.build name: "丽江", slug: "lj"

ljs = lj.scenics.build name: "丽江市", slug: "ljs"
                            
lj.scenics.build name: "玉龙雪山", slug: "ylxs"

lj.places.build name: "束河古镇", slug: "shgz"
lj.places.build name: "拉市海", slug: "lsh"

cmw = lj.recommends.build name: "吃美味", slug: "cmw"
zkz = lj.recommends.build name: "住客栈", slug: "zkz"
dhj = lj.recommends.build name: "带回家", slug: "dhj"

cmw.recommend_records.build name: "丽江小吃"
cmw.recommend_records.build name: "地道菜"
cmw.recommend_records.build name: "外地菜"
cmw.recommend_records.build name: "美食街"

yn.save




