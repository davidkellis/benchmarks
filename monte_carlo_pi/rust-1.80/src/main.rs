use rand::Rng;

fn approx_pi(throws: u64) -> f64 {
    let mut rng = rand::thread_rng();
    let mut inside = 0u64;
    for _ in 0..throws {
        let x: f64 = rng.gen();
        let y: f64 = rng.gen();
        if x.hypot(y) <= 1.0 {
            inside += 1;
        }
    }
    4.0 * inside as f64 / throws as f64
}

fn main() {
    for &n in &[1000, 10000, 100000, 1000000, 10000000] {
        println!("{:8} samples: PI = {}", n, approx_pi(n));
    }
}
