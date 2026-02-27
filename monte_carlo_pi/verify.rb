output = ARGF.read

# Verify that the output contains pi approximation lines with reasonable values
# We check that the 10M sample line produces a value starting with "3.14"
if output.include?("10000000 samples: PI = 3.14")
  exit(0)
else
  exit(1)
end
