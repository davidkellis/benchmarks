def main():
  strings = open('./numbers.txt', 'r').read().split(",")
  ints = list(map(int, strings))
  sorted_ints = quickSort(ints)
  print("\n".join(map(str, sorted_ints[:10])))
  print("\n".join(map(str, sorted_ints[-10:])))


def quickSort(arr):
  less = []
  pivotList = []
  more = []
  if len(arr) <= 1:
    return arr
  else:
    pivot = arr[0]
    for i in arr:
      if i < pivot:
        less.append(i)
      elif i > pivot:
        more.append(i)
      else:
        pivotList.append(i)
    less = quickSort(less)
    more = quickSort(more)
    return less + pivotList + more

main()
