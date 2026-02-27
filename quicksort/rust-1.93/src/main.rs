use std::fs;

fn quicksort(arr: &mut [f64]) {
    let len = arr.len();
    if len <= 1 { return; }
    let pivot = arr[len / 2];
    let mut i = 0usize;
    let mut j = len - 1;
    loop {
        while arr[i] < pivot { i += 1; }
        while arr[j] > pivot { j -= 1; }
        if i >= j { break; }
        arr.swap(i, j);
        i += 1;
        if j == 0 { break; }
        j -= 1;
    }
    let mid = i;
    quicksort(&mut arr[..mid]);
    if mid < len {
        quicksort(&mut arr[mid..]);
    }
}

fn main() {
    let content = fs::read_to_string("numbers.txt").unwrap();
    let mut nums: Vec<f64> = content.lines().map(|l| l.trim().parse().unwrap()).collect();
    quicksort(&mut nums);

    for i in 0..10 { println!("{}", nums[i]); }
    println!("...");
    let n = nums.len();
    for i in (n-10)..n { println!("{}", nums[i]); }
}
