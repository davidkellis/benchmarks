class Array
  def quick_sort
    return self if size <= 1
    pivot = sample
    group = group_by { |x| x <=> pivot }
    (group[-1]? || [] of Int32).quick_sort + group[0] + (group[1]? || [] of Int32).quick_sort
  end
end

def main
  # read and parse the number listing
  numbers = File.read("numbers.txt").strip.split(",").map(&.to_i)
  numbers.quick_sort
end

main