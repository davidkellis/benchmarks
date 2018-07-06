expected_output = "1134903170"

if ARGF.read.include?(expected_output)
  exit(0)
else
  exit(1)
end