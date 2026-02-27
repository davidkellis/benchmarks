#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double approx_pi(int throws) {
    int inside = 0;
    for (int i = 0; i < throws; i++) {
        double x = (double)rand() / RAND_MAX;
        double y = (double)rand() / RAND_MAX;
        if (hypot(x, y) <= 1.0) {
            inside++;
        }
    }
    return 4.0 * inside / throws;
}

int main() {
    int samples[] = {1000, 10000, 100000, 1000000, 10000000};
    int n_samples = sizeof(samples) / sizeof(samples[0]);

    srand(42);
    for (int i = 0; i < n_samples; i++) {
        printf("%8d samples: PI = %f\n", samples[i], approx_pi(samples[i]));
    }
    return 0;
}
