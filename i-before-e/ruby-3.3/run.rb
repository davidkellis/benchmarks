$pattern = /c?ei/

def is_valid(s)
    for capture in s.scan($pattern)
        if !capture.start_with?('c')
            return false
        end
    end
    return true
end

path = ARGV[0]
File.readlines(path).each do |line|
    if !is_valid(line)
        puts line
    end
end