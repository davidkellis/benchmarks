function is_valid(s)
    for m in eachmatch(r"c?ei", s)
        if !startswith(m.match, "c")
            return false
        end
    end
    return true
end

path = ARGS[1]
for line in eachline(path)
    if !is_valid(line)
        println(line)
    end
end
