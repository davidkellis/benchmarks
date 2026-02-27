// function qsort([pivot, ...others]: number[]): number[] {
//   return pivot === 0 ? [] : [
//     ...qsort(others.filter(n => n < pivot)),
//     pivot,
//     ...qsort(others.filter(n => n >= pivot))
//   ];
// }

/**
 * Split array and swap values
 *
 * @param {Array<number>} array
 * @param {number} [left=0]
 * @param {number} [right=array.length - 1]
 * @returns {number}
 */
function partition(array: Array<number>, left: number = 0, right: number = array.length - 1) {
  const pivot = array[Math.floor((right + left) / 2)];
  let i = left;
  let j = right;

  while (i <= j) {
    while (array[i] < pivot) {
      i++;
    }

    while (array[j] > pivot) {
      j--;
    }

    if (i <= j) {
      [array[i], array[j]] = [array[j], array[i]];
      i++;
      j--;
    }
  }

  return i;
}

/**
 * Quicksort implementation
 *
 * @param {Array<number>} array
 * @param {number} [left=0]
 * @param {number} [right=array.length - 1]
 * @returns {Array<number>}
 */
function quickSort(array: Array<number>, left: number = 0, right: number = array.length - 1) {
  let index;

  if (array.length > 1) {
    index = partition(array, left, right);

    if (left < index - 1) {
      quickSort(array, left, index - 1);
    }

    if (index < right) {
      quickSort(array, index, right);
    }
  }

  return array;
}

async function main() {
  // read and parse the number listing
  const numbers = (await Bun.file("numbers.txt").text()).trim().split(",").map(str => parseInt(str));
  const sorted = quickSort(numbers);
  const output = (sorted.slice(0, 10).concat(sorted.slice(-10))).join("\n");
  console.log(output);
}

await main();
