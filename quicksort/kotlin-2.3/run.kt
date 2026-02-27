import java.io.File

fun quickSort(arr: DoubleArray, lo: Int, hi: Int) {
    if (lo >= hi) return
    val pivot = arr[(lo + hi) / 2]
    var i = lo
    var j = hi
    while (i <= j) {
        while (arr[i] < pivot) i++
        while (arr[j] > pivot) j--
        if (i <= j) { val t = arr[i]; arr[i] = arr[j]; arr[j] = t; i++; j-- }
    }
    if (lo < j) quickSort(arr, lo, j)
    if (i < hi) quickSort(arr, i, hi)
}

fun main() {
    val nums = File("numbers.txt").readLines().map { it.trim().toDouble() }.toDoubleArray()
    quickSort(nums, 0, nums.size - 1)

    for (i in 0 until 10) println(nums[i])
    println("...")
    for (i in nums.size - 10 until nums.size) println(nums[i])
}
