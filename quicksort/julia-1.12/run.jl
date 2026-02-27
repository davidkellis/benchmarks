function quicksort!(arr, lo, hi)
    lo >= hi && return
    pivot = arr[div(lo + hi, 2)]
    i, j = lo, hi
    while i <= j
        while arr[i] < pivot; i += 1; end
        while arr[j] > pivot; j -= 1; end
        if i <= j
            arr[i], arr[j] = arr[j], arr[i]
            i += 1; j -= 1
        end
    end
    if lo < j; quicksort!(arr, lo, j); end
    if i < hi; quicksort!(arr, i, hi); end
end

nums = parse.(Float64, readlines("numbers.txt"))
quicksort!(nums, 1, length(nums))

for i in 1:10; println(nums[i]); end
println("...")
for i in (length(nums)-9):length(nums); println(nums[i]); end
