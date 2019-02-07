solution_path = File.expand_path('./solution.txt', File.dirname(__FILE__))
expected_output = File.read(solution_path).strip

observed_output = ARGF.read

if observed_output.include?(expected_output)
  exit(0)
else
  exit(1)
end