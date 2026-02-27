def approx_pi(throws)
  inside = 0
  throws.times do
    x = Random.rand
    y = Random.rand
    inside += 1 if Math.hypot(x, y) <= 1.0
  end
  4.0 * inside / throws
end

[1000, 10_000, 100_000, 1_000_000, 10_000_000].each do |n|
  puts "%8d samples: PI = %s" % [n, approx_pi(n)]
end
