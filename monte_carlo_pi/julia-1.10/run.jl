using Printf

function approx_pi(throws)
    inside = 0
    for _ in 1:throws
        x = rand()
        y = rand()
        if hypot(x, y) <= 1.0
            inside += 1
        end
    end
    return 4.0 * inside / throws
end

for n in [1000, 10_000, 100_000, 1_000_000, 10_000_000]
    @printf("%8d samples: PI = %s\n", n, approx_pi(n))
end
