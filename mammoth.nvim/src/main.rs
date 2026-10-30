//! mammoth: lets Neovim read files far too big to load.
//!
//! Neovim starts this binary with jobstart({ 'mammoth' }, { rpc = true }).
//! Every message arrives on stdin as a msgpack array and every answer leaves on
//! stdout the same way:
//!   request  [0, msgid, method, params]
//!   response [1, msgid, error, result]
use memchr::{memchr, memchr_iter, memmem};
use memmap2::Mmap;
use rmpv::Value;
use std::fs::File;
use std::io::{self, BufReader, BufWriter, Write};
use std::time::Instant;

/// One checkpoint every STEP lines: 2 GB of logs needs a few hundred kilobytes
/// of index instead of the hundreds of megabytes a full line table would take.
const STEP: usize = 1024;

struct BigFile {
    map: Mmap,
    /// marks[k] is the byte where line k * STEP starts.
    marks: Vec<usize>,
    lines: usize,
}

impl BigFile {
    fn open(path: &str) -> io::Result<BigFile> {
        let file = File::open(path)?;
        // The file is mapped, not read: the kernel pages it in only where we look.
        let map = unsafe { Mmap::map(&file)? };
        let mut marks = vec![0];
        let mut lines = 0;
        for nl in memchr_iter(b'\n', &map) {
            lines += 1;
            if lines % STEP == 0 {
                marks.push(nl + 1);
            }
        }
        if map.last().is_some_and(|&b| b != b'\n') {
            lines += 1; // a last line with no newline still counts
        }
        Ok(BigFile { map, marks, lines })
    }

    /// Where line n starts: jump to its checkpoint, then step over at most STEP - 1 lines.
    fn offset(&self, n: usize) -> usize {
        let mut at = self.marks[n / STEP];
        for _ in 0..n % STEP {
            match memchr(b'\n', &self.map[at..]) {
                Some(i) => at += i + 1,
                None => return self.map.len(),
            }
        }
        at
    }

    fn lines(&self, first: usize, count: usize) -> Vec<Value> {
        let mut at = self.offset(first);
        let mut out = Vec::with_capacity(count);
        while out.len() < count && at < self.map.len() {
            let end = memchr(b'\n', &self.map[at..]).map_or(self.map.len(), |i| at + i);
            let text = String::from_utf8_lossy(&self.map[at..end]);
            out.push(Value::from(text.trim_end_matches('\r')));
            at = end + 1;
        }
        out
    }

    /// The line holding byte pos: binary-search the checkpoints, then count the rest.
    fn line_of(&self, pos: usize) -> usize {
        let k = self.marks.partition_point(|&m| m <= pos) - 1;
        k * STEP + memchr_iter(b'\n', &self.map[self.marks[k]..pos]).count()
    }

    fn search(&self, needle: &str, after: usize) -> Option<usize> {
        let start = self.offset(after + 1);
        memmem::find(&self.map[start..], needle.as_bytes()).map(|i| self.line_of(start + i))
    }
}

fn arg(params: &[Value], i: usize) -> Result<&Value, String> {
    params.get(i).ok_or_else(|| format!("missing argument {}", i + 1))
}

fn handle(method: &str, params: &[Value], file: &mut Option<BigFile>) -> Result<Value, String> {
    if method == "open" {
        let path = arg(params, 0)?.as_str().ok_or("path must be a string")?;
        let started = Instant::now();
        let big = BigFile::open(path).map_err(|e| format!("{path}: {e}"))?;
        let info = Value::Map(vec![
            ("lines".into(), big.lines.into()),
            ("bytes".into(), big.map.len().into()),
            ("ms".into(), (started.elapsed().as_millis() as u64).into()),
        ]);
        *file = Some(big);
        return Ok(info);
    }
    let big = file.as_ref().ok_or("no file is open")?;
    match method {
        "lines" => {
            let first = arg(params, 0)?.as_u64().ok_or("first must be a number")? as usize;
            let count = arg(params, 1)?.as_u64().ok_or("count must be a number")? as usize;
            Ok(Value::Array(big.lines(first.min(big.lines), count)))
        }
        "search" => {
            let needle = arg(params, 0)?.as_str().ok_or("pattern must be a string")?;
            let after = arg(params, 1)?.as_u64().ok_or("line must be a number")? as usize;
            Ok(big.search(needle, after).map_or(Value::Nil, Value::from))
        }
        _ => Err(format!("unknown method {method}")),
    }
}

fn main() {
    let mut input = BufReader::new(io::stdin().lock());
    let mut output = BufWriter::new(io::stdout().lock());
    let mut file = None;

    while let Ok(msg) = rmpv::decode::read_value(&mut input) {
        let Value::Array(parts) = msg else { continue };
        // Only requests need an answer; notifications ([2, method, params]) are ignored.
        if parts.len() != 4 || parts[0].as_u64() != Some(0) {
            continue;
        }
        let method = parts[2].as_str().unwrap_or("");
        let params = parts[3].as_array().map(Vec::as_slice).unwrap_or(&[]);
        let (error, result) = match handle(method, params, &mut file) {
            Ok(value) => (Value::Nil, value),
            Err(text) => (Value::from(text), Value::Nil),
        };
        let reply = Value::Array(vec![1.into(), parts[1].clone(), error, result]);
        if rmpv::encode::write_value(&mut output, &reply).is_err() || output.flush().is_err() {
            break;
        }
    }
}
