use regex::Regex;
use std::io::{self, Write};

struct Filter {
    pattern: Regex,
}

impl Filter {
    fn new() -> Self {
        Self {
            pattern: Regex::new("c?ei").unwrap(),
        }
    }

    fn is_valid(&self, s: &str) -> bool {
        for groups in self.pattern.captures_iter(s) {
            if !groups.get(0).unwrap().as_str().starts_with('c') {
                return false;
            }
        }
        true
    }
}

fn main() -> io::Result<()> {
    let handle = io::stdout();
    let filter = Filter::new();

    let mut buf = String::new();
    let mut writer = handle.lock();

    for word in word_list(&mut buf)? {
        if !filter.is_valid(word) {
            writeln!(writer, "{}", word)?;
        }
    }

    Ok(())
}

fn word_list(buf: &mut String) -> io::Result<impl Iterator<Item = &str>> {
    use std::env;
    use std::fs::File;
    use std::io::Read;

    let _ = File::open(env::args().nth(1).expect("Provide filename"))
        .and_then(|mut f| f.read_to_string(buf))?;

    Ok(buf.split_whitespace())
}