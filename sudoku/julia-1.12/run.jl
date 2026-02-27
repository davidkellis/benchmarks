function sd_genmat()
    R = zeros(Int, 729, 4)
    C = zeros(Int, 324, 9)
    nr = zeros(Int, 324)
    for i in 0:728
        r2 = div(i, 9)
        c2 = i % 9
        row = div(r2, 9)
        col = r2 % 9
        box = div(row, 3) * 3 + div(col, 3)
        cc = [9*row + c2, 81 + 9*col + c2, 162 + 9*box + c2, 243 + r2]
        for j in 1:4
            R[i+1, j] = cc[j] + 1
            nr[cc[j]+1] += 1
            C[cc[j]+1, nr[cc[j]+1]] = i + 1
        end
    end
    return R, C
end

function sd_update!(R, C, sr, sc, r, v)
    min_val = 10
    min_c = 0
    for j in 1:4
        sc[R[r,j]] += (v < 0 ? -10 : 10)
    end
    for j in 1:4
        c = R[r,j]
        if v > 0
            for k in 1:9
                rr = C[c,k]
                sr[rr] += 1
                if sr[rr] != 1; continue; end
                for l in 1:4
                    sc[R[rr,l]] -= 1
                    if sc[R[rr,l]] < min_val
                        min_val = sc[R[rr,l]]
                        min_c = R[rr,l]
                    end
                end
            end
        else
            for k in 1:9
                rr = C[c,k]
                sr[rr] -= 1
                if sr[rr] != 0; continue; end
                for l in 1:4
                    sc[R[rr,l]] += 1
                end
            end
        end
    end
    return min_c
end

function sd_solve!(R, C, sr, sc, hints, solution, depth)
    min_val = 10
    best_c = 0
    for i in 1:324
        if sc[i] < min_val
            min_val = sc[i]
            best_c = i
        end
    end
    if min_val == 0 || min_val == 10
        return min_val == 10 ? 1 : 0
    end
    for k in 1:9
        r = C[best_c, k]
        if sr[r] != 0; continue; end
        solution[depth] = r
        sd_update!(R, C, sr, sc, r, 1)
        ret = sd_solve!(R, C, sr, sc, hints, solution, depth + 1)
        if ret > 0; return ret; end
        sd_update!(R, C, sr, sc, r, -1)
    end
    return 0
end

function solve_puzzle(R, C, puzzle)
    sr = zeros(Int, 729)
    sc = fill(9, 324)
    solution = zeros(Int, 81)
    result = collect(puzzle)

    for i in 0:80
        ch = puzzle[i+1]
        if ch >= '1' && ch <= '9'
            r = i * 9 + (ch - '0')
            sd_update!(R, C, sr, sc, r, 1)
        end
    end

    if sd_solve!(R, C, sr, sc, nothing, solution, 1) > 0
        for j in 1:81
            s = solution[j]
            if s > 0
                cell = div(s - 1, 9)
                digit = ((s - 1) % 9) + 1
                if result[cell+1] == '0'
                    result[cell+1] = Char('0' + digit)
                end
            end
        end
    end
    return String(result)
end

function main()
    R, C = sd_genmat()
    lines = readlines("sudoku.txt")
    for iter in 1:10
        for line in lines
            line = strip(line)
            if length(line) >= 81
                println(solve_puzzle(R, C, line))
            end
        end
    end
end

using Printf
main()
