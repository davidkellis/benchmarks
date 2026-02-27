const fs = require("fs");

function quickSort(arr, lo, hi) {
  if (lo >= hi) return;
  const pivot = arr[Math.floor((lo + hi) / 2)];
  let i = lo, j = hi;
  while (i <= j) {
    while (arr[i] < pivot) i++;
    while (arr[j] > pivot) j--;
    if (i <= j) { const t = arr[i]; arr[i] = arr[j]; arr[j] = t; i++; j--; }
  }
  if (lo < j) quickSort(arr, lo, j);
  if (i < hi) quickSort(arr, i, hi);
}

const lines = fs.readFileSync("numbers.txt", "utf8").trim().split("\n");
const nums = lines.map(Number);
quickSort(nums, 0, nums.length - 1);

for (let i = 0; i < 10; i++) console.log(nums[i]);
console.log("...");
for (let i = nums.length - 10; i < nums.length; i++) console.log(nums[i]);
