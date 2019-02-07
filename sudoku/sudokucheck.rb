puzzle = ARGV.first

valid = false

rows = puzzle.each_char.each_slice(9).to_a
cols = rows.transpose

# puts rows.map(&:join).join("\n")
# puts "---"
# puts cols.map(&:join).join("\n")

valid = (rows + cols).all? {|seq| seq.sort.join == '123456789' }

if valid
  puts "valid"
  exit(0)
else
  puts "invalid"
  exit(1)
end