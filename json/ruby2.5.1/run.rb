require "json"

t1 = Time.now

# read and parse the json
json = JSON.parse(File.read("sample.json"))

coordinates = json["coordinates"]
len = coordinates.size
x = y = z = 0

coordinates.each do |coord|
  x += coord['x'].to_f
  y += coord['y'].to_f
  z += coord['z'].to_f
end

p x / len
p y / len
p z / len

t2 = Time.now

puts "json:ruby2.5.1:time=#{t2 - t1}s"
