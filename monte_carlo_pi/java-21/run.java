import java.util.Random;

public class run {
    static double approxPi(int throws) {
        Random rng = new Random();
        int inside = 0;
        for (int i = 0; i < throws; i++) {
            double x = rng.nextDouble();
            double y = rng.nextDouble();
            if (Math.hypot(x, y) <= 1.0) {
                inside++;
            }
        }
        return 4.0 * inside / throws;
    }

    public static void main(String[] args) {
        int[] samples = {1000, 10000, 100000, 1000000, 10000000};
        for (int n : samples) {
            System.out.printf("%8d samples: PI = %s%n", n, approxPi(n));
        }
    }
}
