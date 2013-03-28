# encoding: utf-8;

# Create a user for login
User.create email: "admin@1trip.com", password: "123123"

# Create a proviince.
yn = Province.new name: "云南", slug: "yn"
yn.save

# Create a map for province.
lj = yn.maps.build name: "丽江", slug: "lj"
lj.save

# Create scenics for map
lj.scenics.build name: "丽江市", slug: "ljs"
lj.scenics.build name: "玉龙雪山", slug: "ylxs"

# Create places for map
lj.places.build name: "束河古镇", slug: "shgz"
lj.places.build name: "拉市海", slug: "lsh"

lj.save

# Create recommends for map
cmw = lj.recommends.build name: "吃美味", slug: "cmw"
zkz = lj.recommends.build name: "住客栈", slug: "zkz"
dhj = lj.recommends.build name: "带回家", slug: "dhj"

cmw.save

# Create recommend records for recommend.
cmw.recommend_records.build name: "丽江小吃"
cmw.recommend_records.build name: "地道菜"
cmw.recommend_records.build name: "外地菜"
cmw.recommend_records.build name: "美食街"

cmw.save