// Taken from https://github.com/kostya/benchmarks/blob/master/base64/base64.rs/src/bin/base64.rs

extern crate md5;
extern crate base64;

use base64::{encode, decode};
use std::str;

const STR_SIZE: usize = 1000000;
const TRIES: usize = 20;

fn main() {
  let mut bytes = vec![b'a'; STR_SIZE];
  let mut s = str::from_utf8(&bytes).unwrap().to_string();

  println!("{:x}", md5::compute(&s));

  for _ in 0..TRIES {
    s = encode(&bytes);
    bytes = s.as_bytes().to_vec();
  }
  println!("{:x}", md5::compute(&s));

  for _ in 0..TRIES {
    bytes = decode(&s).unwrap();
    s = str::from_utf8(&bytes).unwrap().to_string();
  }
  println!("{:x}", md5::compute(&s));
}
