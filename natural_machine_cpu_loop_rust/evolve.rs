// The loop with nobody in it.
//
// Version 1 (main.rs) had a human in the loop at three points: I chose the
// domain, I chose the workload, and I chose which mined block to install. Each
// of those is an external step, and a machine with external steps in its loop
// does not improve itself -- it is improved.
//
// This version removes all three:
//
//   * DOMAINS are enumerated exhaustively from a generator, in a fixed order,
//     with no selection. The machine meets whatever comes next.
//   * WORKLOADS are derived from each domain canonically (the base-b expansions
//     of 1..K), so no one picks the test.
//   * INSTALLS are decided by the machine's own exact kernel counters against
//     its own declared measure, and the LIBRARY persists across domains, so a
//     decision made at domain 7 changes what happens at domain 60.
//
// That last point is the whole claim. Self-improvement is not "it compresses";
// it is "what it learned on earlier objects lowers the cost of later objects it
// had not seen when it learned." That is measurable, falsifiable, and it is
// measured below, net of installation cost, against two controls.
//
// Exact integers. No floating point in any decision. No model anywhere.
//
// DETERMINISM (corrected 2026-08-16). This header claimed determinism before
// the program had it: `mine` broke gain-ties by HashMap iteration order, which
// Rust randomises per process, so every run mined a different library and
// printed different totals. The tie-break is now canonical (see `mine`), which
// was the only nondeterminism in the program; the numbers below are now a
// function of the source alone and the same binary prints the same bytes on
// every run. The pre-fix numbers quoted in
// notes/NATURAL_MACHINE_SELF_IMPROVES_WITH_NOBODY_IN_THE_LOOP.md were
// one-process artifacts and are struck through there.
//
//   rustc -O evolve.rs -o evolve && ./evolve

use std::collections::HashMap;

// ------------------------------------------------------------- kernel counter

#[derive(Default, Clone, Copy)]
struct Steps {
    transitions: u64,
    observations: u64,
    comparisons: u64,
}
impl Steps {
    fn total(&self) -> u64 {
        self.transitions + self.observations + self.comparisons
    }
}
impl std::ops::Sub for Steps {
    type Output = Steps;
    fn sub(self, o: Steps) -> Steps {
        Steps {
            transitions: self.transitions.saturating_sub(o.transitions),
            observations: self.observations.saturating_sub(o.observations),
            comparisons: self.comparisons.saturating_sub(o.comparisons),
        }
    }
}
struct Kernel {
    s: Steps,
}
impl Kernel {
    fn new() -> Kernel {
        Kernel { s: Steps::default() }
    }
    fn mark(&self) -> Steps {
        self.s
    }
    fn since(&self, m: Steps) -> Steps {
        self.s - m
    }
}

// -------------------------------------------------------------------- domain

#[derive(Clone)]
struct Domain {
    base: usize,
    modulus: usize,
    n_states: usize,
    n_actions: usize,
    n_primitive: usize,
    delta: Vec<usize>,
    obs: Vec<u8>,
}

impl Domain {
    fn divisibility(base: usize, modulus: usize) -> Domain {
        let mut delta = vec![0usize; modulus * base];
        for r in 0..modulus {
            for d in 0..base {
                delta[r * base + d] = (base * r + d) % modulus;
            }
        }
        Domain {
            base,
            modulus,
            n_states: modulus,
            n_actions: base,
            n_primitive: base,
            delta,
            obs: (0..modulus).map(|r| (r == 0) as u8).collect(),
        }
    }
    fn step(&self, k: &mut Kernel, s: usize, a: usize) -> usize {
        k.s.transitions += 1;
        self.delta[s * self.n_actions + a]
    }
    fn observe(&self, k: &mut Kernel, s: usize) -> u8 {
        k.s.observations += 1;
        self.obs[s]
    }
    fn run(&self, k: &mut Kernel, mut s: usize, w: &[usize]) -> usize {
        for &a in w {
            s = self.step(k, s, a);
        }
        s
    }
    /// Adjoin one composite action for `block`, built by literally composing the
    /// block on every state, then verified exhaustively against its expansion.
    /// The verification is a finite exhaustive check, i.e. a proof, and it is
    /// re-run in every domain -- a macro is never trusted across domains.
    fn install(&self, k: &mut Kernel, block: &[usize]) -> Option<Domain> {
        if block.iter().any(|&a| a >= self.n_primitive) {
            return None; // only primitive blocks transfer; a macro of a macro is
                         // a different object and is not claimed here
        }
        let old_a = self.n_actions;
        let new_a = old_a + 1;
        let mut delta = vec![0usize; self.n_states * new_a];
        for s in 0..self.n_states {
            for a in 0..old_a {
                delta[s * new_a + a] = self.delta[s * old_a + a];
            }
            delta[s * new_a + old_a] = self.run(k, s, block);
        }
        let d = Domain {
            n_actions: new_a,
            delta,
            ..self.clone()
        };
        // exhaustive replay check
        for s in 0..d.n_states {
            let via_macro = d.step(k, s, old_a);
            let via_block = d.run(k, s, block);
            k.s.comparisons += 1;
            if via_macro != via_block {
                return None;
            }
        }
        Some(d)
    }
}

// ------------------------------------------------------- generate + distinguish

fn generate(k: &mut Kernel, d: &Domain) -> Vec<usize> {
    let mut seen = vec![false; d.n_states];
    let mut order = vec![];
    let mut stack = vec![0usize];
    seen[0] = true;
    order.push(0usize);
    while let Some(s) = stack.pop() {
        for a in 0..d.n_primitive {
            let t = d.step(k, s, a);
            k.s.comparisons += 1;
            if !seen[t] {
                seen[t] = true;
                order.push(t);
                stack.push(t);
            }
        }
    }
    order
}

fn distinguish(k: &mut Kernel, d: &Domain, live: &[usize]) -> (Vec<usize>, usize) {
    let mut class_of = vec![0usize; d.n_states];
    for &s in live {
        class_of[s] = d.observe(k, s) as usize;
    }
    let mut n = 2usize;
    loop {
        let mut sigs: Vec<Vec<usize>> = vec![];
        let mut next = vec![0usize; d.n_states];
        for &s in live {
            let mut sig = vec![class_of[s]];
            for a in 0..d.n_primitive {
                let t = d.step(k, s, a);
                sig.push(class_of[t]);
            }
            let mut id = None;
            for (i, o) in sigs.iter().enumerate() {
                k.s.comparisons += 1;
                if *o == sig {
                    id = Some(i);
                    break;
                }
            }
            next[s] = match id {
                Some(i) => i,
                None => {
                    sigs.push(sig);
                    sigs.len() - 1
                }
            };
        }
        k.s.comparisons += 1;
        if sigs.len() == n {
            return (class_of, n);
        }
        n = sigs.len();
        class_of = next;
    }
}

fn quotient(k: &mut Kernel, d: &Domain, live: &[usize], class_of: &[usize], n: usize) -> Domain {
    let mut delta = vec![0usize; n * d.n_primitive];
    let mut obs = vec![0u8; n];
    for &s in live {
        let c = class_of[s];
        obs[c] = d.observe(k, s);
        for a in 0..d.n_primitive {
            let t = d.step(k, s, a);
            delta[c * d.n_primitive + a] = class_of[t];
        }
    }
    Domain {
        base: d.base,
        modulus: d.modulus,
        n_states: n,
        n_actions: d.n_primitive,
        n_primitive: d.n_primitive,
        delta,
        obs,
    }
}

// -------------------------------------------------------------------- workload
//
// Canonical, derived from the domain, chosen by nobody: the base-b expansions of
// 1..K. The machine is tested on the numbers themselves.

fn expansion(mut n: u64, base: usize) -> Vec<usize> {
    if n == 0 {
        return vec![0];
    }
    let b = base as u64;
    let mut v = vec![];
    while n > 0 {
        v.push((n % b) as usize);
        n /= b;
    }
    v.reverse();
    v
}

fn workload(base: usize, k: u64) -> Vec<Vec<usize>> {
    (1..=k).map(|n| expansion(n, base)).collect()
}

/// One query: for each state of the carrier, does this word land on the
/// accepting class? Cost is proportional to carrier size times word length,
/// which is why a smaller carrier and a shorter word both pay.
fn query(k: &mut Kernel, d: &Domain, w: &[usize]) -> usize {
    let mut acc = 0;
    for s in 0..d.n_states {
        let t = d.run(k, s, w);
        let o = d.observe(k, t);
        k.s.comparisons += 1;
        if o == 1 {
            acc += 1;
        }
    }
    acc
}

// -------------------------------------------------------------------- library

#[derive(Clone)]
struct Macro {
    block: Vec<usize>,
    base: usize,     // the alphabet it was learned over
    learned_at: usize, // index of the domain that produced it
}

/// Longest-match folding of a word against the installed macro list.
fn fold(w: &[usize], macros: &[(Vec<usize>, usize)]) -> Vec<usize> {
    let mut out = vec![];
    let mut i = 0;
    'outer: while i < w.len() {
        // longest block first
        let mut best: Option<(usize, usize)> = None;
        for (b, id) in macros {
            if i + b.len() <= w.len() && &w[i..i + b.len()] == &b[..] {
                if best.map_or(true, |(l, _)| b.len() > l) {
                    best = Some((b.len(), *id));
                }
            }
        }
        if let Some((l, id)) = best {
            out.push(id);
            i += l;
            continue 'outer;
        }
        out.push(w[i]);
        i += 1;
    }
    out
}

/// Mine the most-reused contiguous block in this domain's own workload.
/// Installed only if the exact syntax measure of KUTTAKA_TRACE_MACRO pays:
/// a block of length m reused r times has gain (m-1)(r-1)-1.
///
/// TIE-BREAKING IS PART OF THE SPECIFICATION, not an implementation detail.
/// The first version of this function kept a candidate only on `gain > best`
/// and iterated `for (b, r) in count` -- i.e. it broke gain-ties by HashMap
/// iteration order, which Rust randomises per process (RandomState seeds from
/// the OS). Ties are not rare here: at base 4 the four blocks [1,0] [1,1]
/// [1,2] [1,3] all occur equally often in the expansions of 1..40, so which
/// one entered the library was decided by the allocator's mood. Consequences
/// measured before the fix, over six runs of the same binary: the whole-stream
/// learned total ranged 1121166..1121229, the null-library arm ranged -0.03%
/// to +0.14% (it BEAT the no-library arm in one run), and the "what it learned"
/// table came out in a different order every time. A program that prints a
/// different number each time it is run has not measured anything.
///
/// The fix is to return a CANONICAL maximiser: among all blocks of positive
/// gain, over all lengths, take the greatest gain, and break ties by the
/// LEXICOGRAPHICALLY LEAST block (`Vec<usize>`'s `Ord` is lexicographic, with
/// a proper prefix ordered before its extensions). That is a total order on
/// candidates, so the fold below is independent of the order `count` is
/// traversed in -- the HashMap can keep its randomised iteration and the
/// answer is still a function of `words` and `max_len` alone. THE WHOLE
/// PROGRAM IS THEREFORE DETERMINISTIC: this was its only source of
/// run-to-run variation.
///
/// Canonical is not the same as best. Choosing the lexicographically least
/// maximiser is a convention with no claim behind it; what it buys is that
/// the number this program prints is reproducible and can be argued with.
fn mine(words: &[Vec<usize>], max_len: usize) -> Option<(Vec<usize>, i64)> {
    let mut best: Option<(Vec<usize>, i64)> = None;
    for m in 2..=max_len {
        let mut count: HashMap<Vec<usize>, usize> = HashMap::new();
        for w in words {
            if w.len() < m {
                continue;
            }
            for i in 0..=(w.len() - m) {
                *count.entry(w[i..i + m].to_vec()).or_insert(0) += 1;
            }
        }
        for (b, r) in count {
            let gain = (m as i64 - 1) * (r as i64 - 1) - 1;
            if gain <= 0 {
                continue;
            }
            let takes_it = match best.as_ref() {
                None => true,
                Some((bb, g)) => gain > *g || (gain == *g && b < *bb),
            };
            if takes_it {
                best = Some((b, gain));
            }
        }
    }
    best
}

// ----------------------------------------------------------------------- rng
// for the null control only: a library of arbitrary blocks

struct Rng(u64);
impl Rng {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E3779B97F4A7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58476D1CE4E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D049BB133111EB);
        z ^ (z >> 31)
    }
    fn below(&mut self, n: usize) -> usize {
        (self.next() % n as u64) as usize
    }
}

// ---------------------------------------------------------------------- run

/// Process one domain with a given library. Returns (cost, install_cost).
fn process(
    k: &mut Kernel,
    d: &Domain,
    lib: &[Macro],
) -> (u64, u64, usize) {
    let m0 = k.mark();
    let live = generate(k, d);
    let (class_of, n) = distinguish(k, d, &live);
    let q = quotient(k, d, &live, &class_of, n);
    let base_words = workload(d.base, 40);

    // install every applicable library macro into this domain's quotient
    let mut cur = q.clone();
    let mut installed: Vec<(Vec<usize>, usize)> = vec![];
    let mi = k.mark();
    for mac in lib.iter().filter(|m| m.base == d.base) {
        if let Some(next) = cur.install(k, &mac.block) {
            installed.push((mac.block.clone(), next.n_actions - 1));
            cur = next;
        }
    }
    let install_cost = k.since(mi).total();

    let words: Vec<Vec<usize>> = base_words.iter().map(|w| fold(w, &installed)).collect();
    let mq = k.mark();
    for w in &words {
        query(k, &cur, w);
    }
    let _ = k.since(mq);
    let total = k.since(m0).total();
    (total, install_cost, n)
}

fn main() {
    // Arm C's library is arbitrary, so arm C's number is a function of one
    // seed, and a single seed is exactly the kind of quantity this repository
    // is not allowed to publish (CLAUDE.md: a number without its dependence is
    // worse than no number). The seed is therefore an optional argument with
    // the historical default, so `./evolve` reproduces the reported run byte
    // for byte and `./evolve <seed>` re-runs the control elsewhere in seed
    // space. Arms A and B do not read it and do not move.
    let null_seed: u64 = std::env::args()
        .nth(1)
        .and_then(|s| s.parse().ok())
        .unwrap_or(0x5EED);

    // The stream of domains: exhaustive, ordered, unselected.
    let mut stream: Vec<Domain> = vec![];
    for m in 2..=60usize {
        for b in 2..=4usize {
            stream.push(Domain::divisibility(b, m));
        }
    }

    println!("natural machine v2 -- no external step in the loop");
    println!("  domains enumerated, not chosen : {}", stream.len());
    println!("  workload derived, not chosen   : base-b expansions of 1..40");
    println!("  installs decided by the machine's own kernel counters");
    println!("  arm C null-library seed         : {} (deterministic; arms A,B seed-free)", null_seed);
    println!();

    // ---- arm A: no library ever (the machine that does not learn)
    let mut ka = Kernel::new();
    let mut cost_a = vec![];
    for d in &stream {
        let (c, _, _) = process(&mut ka, d, &[]);
        cost_a.push(c);
    }

    // ---- arm B: the machine learns, and carries what it learns forward
    let mut kb = Kernel::new();
    let mut lib: Vec<Macro> = vec![];
    let mut cost_b = vec![];
    let mut lib_growth = vec![];
    for (i, d) in stream.iter().enumerate() {
        let (c, _inst, _n) = process(&mut kb, d, &lib);
        cost_b.push(c);
        // mine from THIS domain, for the benefit of later ones
        let words = workload(d.base, 40);
        if let Some((block, _gain)) = mine(&words, 6) {
            if !lib.iter().any(|m| m.block == block && m.base == d.base) {
                lib.push(Macro { block, base: d.base, learned_at: i });
            }
        }
        lib_growth.push(lib.len());
    }

    // ---- arm C: null control -- a library of arbitrary blocks of the same size
    let mut kc = Kernel::new();
    let mut rng = Rng(null_seed);
    let mut null_lib: Vec<Macro> = vec![];
    let mut cost_c = vec![];
    for (i, d) in stream.iter().enumerate() {
        let (c, _, _) = process(&mut kc, d, &null_lib);
        cost_c.push(c);
        while null_lib.len() < lib_growth[i] {
            let base = 2 + rng.below(3);
            let len = 2 + rng.below(4);
            let block: Vec<usize> = (0..len).map(|_| rng.below(base)).collect();
            null_lib.push(Macro { block, base, learned_at: i });
        }
    }

    // ---------------------------------------------------------------- report
    println!("  domain      no-library      learned      null-library   learned vs none");
    for i in (0..stream.len()).step_by(20) {
        println!(
            "  {:>3} (b{},m{:>2})  {:>10}  {:>11}  {:>13}   {:>+6.2}%",
            i,
            stream[i].base,
            stream[i].modulus,
            cost_a[i],
            cost_b[i],
            cost_c[i],
            100.0 * (cost_b[i] as f64 - cost_a[i] as f64) / cost_a[i] as f64
        );
    }

    let sum = |v: &Vec<u64>| v.iter().sum::<u64>();
    let (ta, tb, tc) = (sum(&cost_a), sum(&cost_b), sum(&cost_c));
    println!();
    println!("  total kernel steps over the whole stream");
    println!("    no library      {:>12}", ta);
    println!("    learned library {:>12}   ({:+.2}%)", tb, 100.0 * (tb as f64 - ta as f64) / ta as f64);
    println!("    null library    {:>12}   ({:+.2}%)", tc, 100.0 * (tc as f64 - ta as f64) / ta as f64);
    println!("    library size at end: {}", lib.len());
    println!("\n  what it learned, unprompted:");
    for m in &lib {
        println!(
            "    block {:?} over base {}, learned at domain {}",
            m.block, m.base, m.learned_at
        );
    }

    // The claim that matters: does what it learned EARLY pay on domains it had
    // not seen when it learned? Compare the second half only, where the library
    // was already populated by the first half.
    let h = stream.len() / 2;
    let (a2, b2, c2): (u64, u64, u64) = (
        cost_a[h..].iter().sum(),
        cost_b[h..].iter().sum(),
        cost_c[h..].iter().sum(),
    );
    println!();
    println!("  SECOND HALF ONLY -- domains unseen when the library was built");
    println!("    no library      {:>12}", a2);
    println!("    learned library {:>12}   ({:+.2}%)", b2, 100.0 * (b2 as f64 - a2 as f64) / a2 as f64);
    println!("    null library    {:>12}   ({:+.2}%)", c2, 100.0 * (c2 as f64 - a2 as f64) / a2 as f64);
    println!();
    println!("  SELF-IMPROVEMENT (learned beats no-library on unseen domains): {}", b2 < a2);
    // Arm B carries no seed, so the line above is a property of the program.
    // The line below is NOT: it is one draw of a 3-block arbitrary library.
    // Over seeds 1..60 this boolean comes out false 20 times and true 40, with
    // arm C spanning -4.61%..+3.42% about a median of +0.90% -- so the strict
    // control neither passes nor fails as a fact, and reading a single run as
    // if it did is how the pre-fix "+0.21%, control holds" was published. What
    // is seed-independent is the SEPARATION, reported on the next line: over
    // those same 60 seeds the learned library beat the arbitrary one 60 times
    // out of 60, the best arbitrary draw reaching only -4.61% against arm B's
    // -5.70%.
    println!("  NULL CONTROL     (one seed only -- see the seed sweep, not this line): {}", c2 >= a2);
    println!("  SEPARATION       (learned beats the SAME-SIZE arbitrary library): {}  ({} vs {})",
             b2 < c2, b2, c2);
}
