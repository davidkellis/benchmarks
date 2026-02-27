#include <stdio.h>
#include <stdlib.h>

void quicksort(double *arr, int lo, int hi) {
    if (lo >= hi) return;
    double pivot = arr[(lo + hi) / 2];
    int i = lo, j = hi;
    while (i <= j) {
        while (arr[i] < pivot) i++;
        while (arr[j] > pivot) j--;
        if (i <= j) { double t = arr[i]; arr[i] = arr[j]; arr[j] = t; i++; j--; }
    }
    if (lo < j) quicksort(arr, lo, j);
    if (i < hi) quicksort(arr, i, hi);
}

int main() {
    FILE *f = fopen("numbers.txt", "r");
    if (!f) { perror("fopen"); return 1; }

    int capacity = 10000000;
    double *nums = malloc(capacity * sizeof(double));
    int count = 0;
    char line[64];
    while (fgets(line, sizeof(line), f)) {
        nums[count++] = atof(line);
    }
    fclose(f);

    quicksort(nums, 0, count - 1);

    for (int i = 0; i < 10; i++) printf("%f\n", nums[i]);
    printf("...\n");
    for (int i = count - 10; i < count; i++) printf("%f\n", nums[i]);

    free(nums);
    return 0;
}
