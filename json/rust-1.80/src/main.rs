use std::fs;

use serde::Deserialize;

#[derive(Deserialize)]
pub struct Coordinate {
    x: f64,
    y: f64,
    z: f64,
}

#[derive(Deserialize)]
pub struct TestStruct {
    coordinates: Vec<Coordinate>,
}

fn main() {
    let text = fs::read_to_string("sample.json").unwrap();
    let json: TestStruct = serde_json::from_str(&text).unwrap();
    let coords = json.coordinates;

    let len = coords.len() as f64;
    let mut x = 0_f64;
    let mut y = 0_f64;
    let mut z = 0_f64;

    for coord in &coords {
        x += coord.x;
        y += coord.y;
        z += coord.z;
    }

    println!("{}\n{}\n{}", x / len, y / len, z / len);
}
