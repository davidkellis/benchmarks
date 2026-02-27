def sd_genmat()
	mr = Array.new(324) { [] }
	mc = Array.new(729) { [] }
	r = 0
	(0...729).each do |n|
		mc[n] = [n/9, n/81*9 + n%9 + 81, n%81 + 162, n%9*9 + n/243*3 + n/27%3 + 243]
	end
	(0...729).each do |r|
		(0...4).each do |c2|
			mr[mc[r][c2]].push(r)
		end
	end
	return mr, mc
end

def sd_update(mr, mc, sr, sc, r, v)
	m = 10
	m_c = 0
	for c in mc[r]
		sc[c] += v << 7
	end
	for c in mc[r]
		if v > 0
			for rr in mr[c]
				sr[rr] += 1
				if sr[rr] == 1
					for cc in mc[rr]
						sc[cc] -= 1
						if sc[cc] < m
							m, m_c = sc[cc], cc
						end
					end
				end
			end
		else
			for rr in mr[c]
				sr[rr] -= 1
				if sr[rr] == 0
					p = mc[rr]
					sc[p[0]] += 1
					sc[p[1]] += 1
					sc[p[2]] += 1
					sc[p[3]] += 1
				end
			end
		end
	end
	[m, m_c]
end

def sd_solve(mr, mc, s)
	ret, out, hints = [], [], 0
	sr = [0] * 729
	sc = [9] * 324
	cr = [-1] * 81
	cc = [-1] * 81
	for i in 0...81
		if s[i].ord >= 49 && s[i].ord <= 57
			a = s[i].ord - 49
		else
			a = -1
		end
		if a >= 0
			sd_update(mr, mc, sr, sc, i * 9 + a, 1)
			hints += 1
		end
		out.append(a + 1)
	end
	i, m, d = 0, 10, 1
	while true
		while i >= 0 && i < 81 - hints
			if d == 1
				if m > 1
					for c in 0...324
						if sc[c] < m
							m, cc[i] = sc[c], c
							break if m < 2
						end
					end
				end
				if m == 0 || m == 10
					cr[i], d = -1, -1
					i -= 1
				end
			end
			c = cc[i]
			if d == -1 && cr[i] >= 0
				sd_update(mr, mc, sr, sc, mr[c][cr[i]], -1)
			end
			r2_ = 9
			for r2 in (cr[i] + 1)...9
				if sr[mr[c][r2]] == 0
					r2_ = r2
					break
				end
			end
			if r2_ < 9
				m, cc[i+1] = sd_update(mr, mc, sr, sc, mr[c][r2_], 1)
				cr[i], d = r2_, 1
				i += 1
			else
				cr[i], d = -1, -1
				i -= 1
			end
		end
		break if i < 0
		y = out[0...81]
		for j in 0...i
			r = mr[cc[j]][cr[j]]
			y[r/9] = r%9 + 1
		end
		ret << y
		i -= 1
		d = -1
	end
	ret
end

mr, mc = sd_genmat()
lines = File.readlines("./sudoku.txt")
10.times do
  lines.each do |line|
    if line.length >= 81
      ret = sd_solve(mr, mc, line)
      puts ret.map {|s| s.join }.join
    end
  end
end