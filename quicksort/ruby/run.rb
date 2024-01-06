class Array
  # # Taken from http://rosettacode.org/wiki/Sorting_algorithms/Quicksort#Ruby
  # def quick_sort
  #   return self if size <= 1
  #   pivot = sample
  #   group = group_by { |x| x <=> pivot }
  #   (group[-1] || []).quick_sort + group[0] + (group[1] || []).quick_sort
  # end

  def quick_sort(first = 0, last = self.size - 1)
    if first < last
      p_index = quick_sort_partition(first, last)
      self.quick_sort(first, p_index - 1)
      self.quick_sort(p_index + 1, last)
    end

    self
  end

  def quick_sort_partition(first, last)
    # first select one element from the list, can be any element.
    # rearrange the list so all elements less than pivot are left of it, elements greater than pivot are right of it.
    pivot = self[last]
    p_index = first

    i = first
    while i < last
      if self[i] <= pivot
        temp = self[i]
        self[i] = self[p_index]
        self[p_index] = temp
        p_index += 1
      end
      i += 1
    end
    temp = self[p_index]
    self[p_index] = pivot
    self[last] = temp
    return p_index
  end

end

def main
  # read and parse the number listing
  numbers = File.read("numbers.txt").strip.split(",").map(&:to_i)
  sorted = numbers.quick_sort
  puts (sorted.take(10) + sorted[-10..-1]).join("\n")
end

main
