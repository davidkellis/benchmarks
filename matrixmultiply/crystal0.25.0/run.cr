def rand_matrix(n)
  # rows = n.times.map { n.times.map { rand } }
  rows = (n*n).times.map { rand }.each_slice(n).to_a
end

def matmul(a, b)
  a.map do |ar|
    b.transpose.map do |bc|
      ar.zip(bc).map {|pair| pair.reduce(1.0) {|a,b| a*b} }.reduce(&.+)
    end
  end
end

def main
  n = (ARGV[0]? || 5).to_i

  n.times do
    a = rand_matrix(1000)
    b = rand_matrix(1000)
    c = matmul(a,b)
  end
end

main