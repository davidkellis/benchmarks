import os

fn quicksort(mut arr []f64, lo int, hi int) {
	if lo >= hi {
		return
	}
	pivot := arr[(lo + hi) / 2]
	mut i := lo
	mut j := hi
	for i <= j {
		for arr[i] < pivot {
			i++
		}
		for arr[j] > pivot {
			j--
		}
		if i <= j {
			arr[i], arr[j] = arr[j], arr[i]
			i++
			j--
		}
	}
	if lo < j {
		quicksort(mut arr, lo, j)
	}
	if i < hi {
		quicksort(mut arr, i, hi)
	}
}

fn main() {
	lines := os.read_lines('numbers.txt') or { panic(err) }
	mut nums := []f64{len: lines.len}
	for idx, line in lines {
		nums[idx] = line.trim_space().f64()
	}
	quicksort(mut nums, 0, nums.len - 1)

	for i in 0 .. 10 {
		println(nums[i])
	}
	println('...')
	for i in nums.len - 10 .. nums.len {
		println(nums[i])
	}
}
