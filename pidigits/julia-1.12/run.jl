function pidigits(n)
    q, r, t, k, n_d, l = big"1", big"0", big"1", big"1", big"3", big"3"
    count = 0
    buf = IOBuffer()

    while count < n
        if 4 * q + r - t < n_d * t
            write(buf, string(n_d))
            count += 1
            if count % 10 == 0
                write(buf, "\t:$(count)\n")
            end
            nr = 10 * (r - n_d * t)
            n_d = div(10 * (3 * q + r), t) - 10 * n_d
            q *= 10
            r = nr
        else
            nr = (2 * q + r) * l
            nn = div(q * (7 * k + 2) + r * l, t * l)
            q *= k
            t *= l
            l += 2
            k += 1
            n_d = nn
            r = nr
        end
    end

    if count % 10 != 0
        spaces = 10 - count % 10
        write(buf, " " ^ spaces * "\t:$(count)\n")
    end
    print(String(take!(buf)))
end

n = length(ARGS) >= 1 ? parse(Int, ARGS[1]) : 10000
pidigits(n)
