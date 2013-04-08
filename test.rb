a =[]
b = []

1000000.times do
  a << Random.new_seed.to_s.split(//).shuffle!.sample(12).shuffle!.join()
end

puts a.size
b = a.uniq
puts b.size