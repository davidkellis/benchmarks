def sd_genmat()
	mr: Array(Array(Int32)) = Array.new(324) { [] of Int32 }
	mc: Array(Array(Int32)) = Array.new(729) { [] of Int32 }
	r = 0
	(0...9).each do |i|
		(0...9).each do |j|
			(0...9).each do |k|
				mc[r] = [ 9 * i + j, (i/3*3 + j/3) * 9 + k + 81, 9 * i + k + 162, 9 * j + k + 243 ]
				r += 1
			end
		end
	end
	(0...729).each do |r|
		(0...4).each do |c2|
			mr[mc[r][c2]].push(r)
		end
	end
	return mr, mc
end

def sd_update(mr, mc, sr, sc, r, v)
	(0...4).each do |c2|
		c = mc[r][c2]
		sc[c] += v
		mr[c].each do |p| sr[p] += v end
	end
end

def sd_solve(mr, mc, s)
	ret, sr, sc, hints = [] of Array(Int32), Array.new(729) { 0 }, Array.new(324) { 0 }, 0
	(0...81).each do |i|
		a = (s[i].ord >= '1'.ord && s[i].ord <= '9'.ord) ? s[i].ord - 49 : -1
    if a >= 0
      sd_update(mr, mc, sr, sc, i * 9 + a, 1); hints += 1
    end
	end
	cr, cc = Array.new(81) { -1 }, Array.new(81) { -1 }
	i, c0, dir = 0, 0, 1
	loop do
		while i >= 0 && i < 81 - hints
			if dir == 1
				min = 10
				(0...324).each do |j|
					c = j + c0 < 324? j + c0 : j + c0 - 324
          next if sc[c] != 0
					n = 0
					mr[c].each {|p| n += 1 if sr[p] == 0 }
          if n < min
            min, cc[i], c0 = n, c, c + 1
          end
					break if n <= 1
				end
        if min == 0 || min == 10
          cr[i], dir, i = -1, -1, i - 1
        end
			end
			c = cc[i]
      if dir == -1 && cr[i] >= 0
        sd_update(mr, mc, sr, sc, mr[c][cr[i]], -1)
      end
			r2_ = 9
			(cr[i]+1...9).each do |r2|
        if sr[mr[c][r2]] == 0
          r2_ = r2
          break
        end
			end
			if r2_ < 9
				sd_update(mr, mc, sr, sc, mr[c][r2_], 1)
				cr[i], dir, i = r2_, 1, i + 1
      else
        cr[i], dir, i = -1, -1, i - 1
      end
		end
		break if i < 0
		o = [] of Int32
    (0...81).each do |j|
      o.push(s[j].ord - 49)
    end
		(0...i).each do |j|
			r = mr[cc[j]][cr[j]]
			o[r/9] = r % 9 + 1
		end
		ret.push(o)
		i, dir = i - 1, -1
	end
	return ret
end

mr, mc = sd_genmat()
lines = File.read_lines("./sudoku.txt")
50.times do
  lines.each do |line|
    if line.size >= 81
      ret = sd_solve(mr, mc, line)
      ret.each {|s| puts s.join }
      puts
    end
  end
end
