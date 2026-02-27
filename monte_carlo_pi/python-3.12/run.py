import random
import math

def approx_pi(throws):
    inside = 0
    for _ in range(throws):
        x = random.random()
        y = random.random()
        if math.hypot(x, y) <= 1.0:
            inside += 1
    return 4.0 * inside / throws

for n in [1000, 10000, 100000, 1000000, 10000000]:
    print("%8d samples: PI = %s" % (n, approx_pi(n)))
