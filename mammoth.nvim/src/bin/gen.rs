//! Write a realistic web-server log of a given size, deterministically.
//!   cargo run --release --bin gen -- big.log 2G
use std::fs::File;
use std::io::{BufWriter, Write};

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let path = args.get(1).map(String::as_str).unwrap_or("big.log");
    let size = parse_size(args.get(2).map(String::as_str).unwrap_or("2G"));
    let mut out = BufWriter::with_capacity(1 << 20, File::create(path).expect("cannot create file"));

    let paths = ["/api/tasks", "/api/users", "/login", "/api/search", "/health", "/api/tasks/export"];
    let users = ["anika", "ben", "chloe", "dev", "ela", "farid", "grace", "hiro"];
    let mut seed: u64 = 0x9e37_79b9_7f4a_7c15;
    let mut rand = move || {
        seed ^= seed << 13;
        seed ^= seed >> 7;
        seed ^= seed << 17;
        seed
    };

    let mut written = 0u64;
    let mut n = 0u64;
    let panic_at = size / 100 * 97; // one needle near the end, for the search demo
    let mut planted = false;
    while written < size {
        n += 1;
        let r = rand();
        let (h, m, s, ms) = ((n / 3_600_000) % 24, (n / 60_000) % 60, (n / 1000) % 60, n % 1000);
        let line = if !planted && written >= panic_at {
            planted = true;
            format!("2026-10-25T{h:02}:{m:02}:{s:02}.{ms:03}Z ERROR req={n:010} worker 7 panicked: disk quota exceeded on /var/data\n")
        } else {
            let status = match r % 50 { 0 => 500, 1..=3 => 404, 4..=6 => 302, _ => 200 };
            let level = if status == 500 { "WARN " } else { "INFO " };
            format!(
                "2026-10-25T{h:02}:{m:02}:{s:02}.{ms:03}Z {level} req={n:010} GET {} {status} {}ms user={}\n",
                paths[(r >> 8) as usize % paths.len()],
                (r >> 16) % 900 + 3,
                users[(r >> 24) as usize % users.len()],
            )
        };
        out.write_all(line.as_bytes()).unwrap();
        written += line.len() as u64;
    }
    out.flush().unwrap();
    eprintln!("{path}: {n} lines, {written} bytes");
}

fn parse_size(s: &str) -> u64 {
    let (num, unit) = s.split_at(s.trim_end_matches(|c: char| c.is_alphabetic()).len());
    let n: f64 = num.parse().expect("size like 2G or 500M");
    let mult = match unit.to_ascii_uppercase().as_str() {
        "G" | "GB" => 1u64 << 30,
        "M" | "MB" => 1 << 20,
        "K" | "KB" => 1 << 10,
        _ => 1,
    };
    (n * mult as f64) as u64
}
