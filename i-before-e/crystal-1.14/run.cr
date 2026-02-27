Pattern = /c?ei/

def is_valid(s)
    s.scan(Pattern).each do |capture|
        if !capture[0].starts_with?("c")
            return false
        end
    end
    true
end

path = ARGV[0]
File.read_lines(path).each do |line|
    if !is_valid(line)
        puts line
    end
end