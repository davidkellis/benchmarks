public class run {
	public static int fib(int n) {
		if (n <= 2) {
			return 1;
		} else {
			return fib(n - 1) + fib(n - 2);
		}
	}

	public static void main(final String[] args) throws Exception {
		System.out.println(fib(45));
	}
}