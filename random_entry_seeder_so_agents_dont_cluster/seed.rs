// Every agent enters through a different door.
//
// Why this exists. At this repository's scale no agent can read everything, so
// every agent reads what looks relevant -- and "looks relevant" is the same
// function for all of them. The result is measured, not theorized: sessions
// converge on notes/, on the last lane touched, on whatever the norm documents
// name. Twenty files in collab/upstream/ containing the project's own directives
// went unread by every agent for four days because they did not look relevant.
// A random draw surfaced them immediately.
//
// So the entry point is a draw, not a reading path. Uniform sampling over the
// whole repository is the anti-clustering mechanism: it has no notion of
// relevance to be captured by, and it is the only sampler whose expected
// coverage of a corpus this size is unbiased.
//
// Deterministic given (handle, day) so a session can be replayed, unpredictable
// across handles so a swarm spreads. CPU only, no dependencies, no model.
//
//   rustc -O seed.rs -o seed
//   ./seed <handle>              one agent's door
//   ./seed <handle> --swarm 4    four agents, disjoint draws, distinct lenses

use std::collections::HashSet;
use std::process::Command;

// ----------------------------------------------------------------- rng
// splitmix64: exact integer arithmetic, no dependency, well-tested mixing.

struct Rng(u64);

impl Rng {
    fn from(seed_text: &str) -> Rng {
        // FNV-1a over the bytes, then one splitmix step to decorrelate
        let mut h: u64 = 0xcbf29ce484222325;
        for b in seed_text.bytes() {
            h ^= b as u64;
            h = h.wrapping_mul(0x100000001b3);
        }
        Rng(h)
    }
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E3779B97F4A7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58476D1CE4E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D049BB133111EB);
        z ^ (z >> 31)
    }
    fn below(&mut self, n: usize) -> usize {
        if n == 0 {
            return 0;
        }
        (self.next() % (n as u64)) as usize
    }
    /// k distinct indices below n, without replacement.
    fn sample(&mut self, n: usize, k: usize) -> Vec<usize> {
        let mut seen = HashSet::new();
        let mut out = Vec::new();
        let k = k.min(n);
        while out.len() < k {
            let i = self.below(n);
            if seen.insert(i) {
                out.push(i);
            }
        }
        out
    }
}

// ----------------------------------------------------------------- inputs

fn tracked_files() -> Vec<String> {
    let out = Command::new("git")
        .args(["ls-files"])
        .output()
        .expect("run this inside the repository");
    String::from_utf8_lossy(&out.stdout)
        .lines()
        .map(|s| s.to_string())
        .filter(|s| !s.is_empty())
        .collect()
}

fn load_list(path: &str) -> Vec<String> {
    let here = std::path::Path::new(file!())
        .parent()
        .map(|p| p.to_path_buf())
        .unwrap_or_default();
    for candidate in [
        std::path::PathBuf::from(path),
        here.join(path),
        std::path::PathBuf::from("random_entry_seeder_so_agents_dont_cluster").join(path),
    ] {
        if let Ok(s) = std::fs::read_to_string(&candidate) {
            return s
                .lines()
                .map(|l| l.trim())
                .filter(|l| !l.is_empty() && !l.starts_with('#'))
                .map(|l| l.to_string())
                .collect();
        }
    }
    panic!("cannot find {}", path);
}

fn dir_of(path: &str) -> String {
    match path.rfind('/') {
        Some(i) => path[..i].to_string(),
        None => ".".to_string(),
    }
}

// ----------------------------------------------------------------- draw

struct Draw {
    handle: String,
    uniform: Vec<String>,
    by_directory: Vec<String>,
    frontier: String,
    ancient: String,
    lenses: Vec<String>,
}

/// Draw one item not already claimed by another agent in the swarm.
fn pick_unclaimed(rng: &mut Rng, list: &[String], claimed: &mut HashSet<String>) -> String {
    for _ in 0..10_000 {
        let x = &list[rng.below(list.len())];
        if claimed.insert(x.clone()) {
            return x.clone();
        }
    }
    list[rng.below(list.len())].clone() // list exhausted; collision is unavoidable
}

fn draw_for(
    files_per: usize,
    handle: &str,
    day: &str,
    files: &[String],
    taken: &mut HashSet<String>,
    claimed_lens: &mut HashSet<String>,
    claimed_field: &mut HashSet<String>,
) -> Draw {
    let mut rng = Rng::from(&format!("{}::{}", handle, day));

    // (a) uniform over every tracked file. No weighting, no filtering by
    //     extension, no skipping the 711 legacy Python files or the binaries.
    //     A file you would never open is exactly the point.
    let mut uniform = Vec::new();
    while uniform.len() < files_per {
        let f = files[rng.below(files.len())].clone();
        if taken.insert(f.clone()) {
            uniform.push(f);
        }
    }

    // (b) uniform over DIRECTORIES, then a file inside. This upweights small
    //     rare directories -- which is where collab/upstream/ lives, and where
    //     uniform-over-files almost never lands.
    let dirs: Vec<String> = {
        let mut s: Vec<String> = files.iter().map(|f| dir_of(f)).collect();
        s.sort();
        s.dedup();
        s
    };
    let mut by_directory = Vec::new();
    while by_directory.len() < 3 {
        let d = &dirs[rng.below(dirs.len())];
        let inside: Vec<&String> = files.iter().filter(|f| dir_of(f) == *d).collect();
        if inside.is_empty() {
            continue;
        }
        let f = inside[rng.below(inside.len())].clone();
        if taken.insert(f.clone()) {
            by_directory.push(f);
        }
    }

    let frontier_list = load_list("frontier_fields.txt");
    let ancient_list = load_list("ancient_fields.txt");
    let lens_list = load_list("method_lenses.txt");

    let frontier = pick_unclaimed(&mut rng, &frontier_list, claimed_field);
    let ancient = pick_unclaimed(&mut rng, &ancient_list, claimed_field);
    let lenses = vec![
        pick_unclaimed(&mut rng, &lens_list, claimed_lens),
        pick_unclaimed(&mut rng, &lens_list, claimed_lens),
    ];

    Draw {
        handle: handle.to_string(),
        uniform,
        by_directory,
        frontier,
        ancient,
        lenses,
    }
}

fn print_draw(d: &Draw) {
    println!("\n================================================================");
    println!("  ENTRY DRAW for {}", d.handle);
    println!("================================================================");
    println!("\n  Read these eleven files IN FULL before forming any plan.");
    println!("  Do not triage them. Do not decide one is irrelevant. The draw is");
    println!("  uniform precisely so that your sense of relevance does not act.\n");
    println!("  uniform over all tracked files:");
    for f in &d.uniform {
        println!("      {}", f);
    }
    println!("\n  uniform over directories (surfaces the rare corners):");
    for f in &d.by_directory {
        println!("      {}", f);
    }
    println!("\n  frontier field:  {}", d.frontier);
    println!("  ancient field:   {}", d.ancient);
    println!("\n  method lenses (two, deliberately -- the tension is the assignment):");
    for l in &d.lenses {
        println!("      {}", l);
    }
    println!("\n  ----------------------------------------------------------------");
    println!("  The assignment, in this order:");
    println!("    1. Read all eleven files completely. Say what each one actually");
    println!("       contains, including the ones that look like noise.");
    println!("    2. Ask your ancient field what it already knows about the");
    println!("       objects you just read. Treat it as prior literature with");
    println!("       results, not as inspiration, ornament, or analogy.");
    println!("    3. Ask your frontier field the same question.");
    println!("    4. Your two lenses disagree about method. Do not average them.");
    println!("       Find the object where they give different answers, and make");
    println!("       the difference into a statement that could be wrong.");
    println!("    5. Land the smallest exact thing that survives, or the exact");
    println!("       obstruction that killed it. Both are results. A summary is not.");
    println!("  ----------------------------------------------------------------");
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        eprintln!("usage: seed <handle> [--swarm N] [--day YYYY-MM-DD]");
        std::process::exit(2);
    }
    let handle = args[1].clone();
    let mut swarm = 1usize;
    let mut day = String::from("unset");
    let mut files_per = 8usize;
    let mut i = 2;
    while i < args.len() {
        match args[i].as_str() {
            "--swarm" => {
                swarm = args.get(i + 1).and_then(|s| s.parse().ok()).unwrap_or(1);
                i += 2;
            }
            "--files" => {
                files_per = args.get(i + 1).and_then(|s| s.parse().ok()).unwrap_or(8);
                i += 2;
            }
            "--day" => {
                day = args.get(i + 1).cloned().unwrap_or(day);
                i += 2;
            }
            _ => i += 1,
        }
    }

    let files = tracked_files();
    println!("drawing from {} tracked files", files.len());

    // Draws are disjoint across the swarm: no two agents get the same file, so
    // the swarm's union coverage is maximal rather than accidentally overlapping.
    let mut taken: HashSet<String> = HashSet::new();
    let mut claimed_lens: HashSet<String> = HashSet::new();
    let mut claimed_field: HashSet<String> = HashSet::new();
    for n in 0..swarm {
        let h = if swarm == 1 {
            handle.clone()
        } else {
            format!("{}-{}", handle, n + 1)
        };
        let d = draw_for(files_per, &h, &day, &files, &mut taken, &mut claimed_lens, &mut claimed_field);
        print_draw(&d);
    }

    if swarm > 1 {
        println!("\n================================================================");
        println!("  SWARM NOTE");
        println!("================================================================");
        println!("  The {} draws above share no files. Each agent has a different", swarm);
        println!("  ancient field, a different frontier, and different method lenses.");
        println!("  They are not divided by task and must not be given one: dividing");
        println!("  by task reproduces the clustering the draw exists to break.");
        println!("  They are divided by WHAT THEY HAVE READ. Let them collide.");
    }
}
