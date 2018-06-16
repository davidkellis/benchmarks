require "json"

t1 = Time.now

# read and parse the json
jobj = JSON.parse(File.read("sample.json"))

coordinates = jobj["coordinates"].as_a
len = coordinates.size
x = y = z = 0

coordinates.each do |coord|
  x += coord["x"].as_f
  y += coord["y"].as_f
  z += coord["z"].as_f
end

p x / len
p y / len
p z / len

t2 = Time.now

puts "json:crystal0.25.0:time=#{t2 - t1}s"
