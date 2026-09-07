// The natural machine, executing on its own on a CPU.
//
// Exact integer arithmetic. No floating point. No model anywhere in the loop.
// Deterministic: same binary, same output, every run.
//
// This program measures COST ONLY. It never decides truth. Every mathematical
// statement it relies on is either proved in notes/NATURAL_MACHINE_CPU_LOOP.md
// or already checked in formal/pairfield (FutureBehavior.lean, BehavioralBFS.lean),
// whose constructions this file is the executable face of:
//
//     run / behavior / FutureEq / futureSetoid / quotientStep   <- FutureBehavior.lean
//     shortestDistinguishingUpTo (+ sound, minimal)             <- BehavioralBFS.lean
//
// The one thing those checked terms deliberately do not assert is the
// finite-dimensional COST statement (InvariantCorrectiveClosure.lean says so in
// its own docstring: "No finite-dimensional termination, rank, stochastic
// lumpability, or partition-quotient theorem is asserted here"). That is exactly
// what the counters below supply.
//
// The loop, per legacy/runtime/CRYSTAL.md section 7:
//
//     GENERATE     reachable states from constructors
//     DISTINGUISH  Myhill-Nerode refinement; shortest separating witnesses
//     CRYSTALLIZE  mine a repeated action block, install it as one primitive
//     ROUTE        direct vs compiled, chosen by exact horizon cost
//     REOPEN       admit a new action; price one-step vs persistent correction
//
// and the seed criterion of CRYSTAL.md section 0 is what the program is FOR:
// a fact enters; an INDEPENDENT problem thereafter solves in strictly fewer
// kernel steps; a null control must not reduce it.

use std::fmt::Write as _;

// ---------------------------------------------------------------- counters

#[derive(Default, Clone, Copy, PartialEq, Eq)]
struct Steps {
    transitions: u64,  // one application of the step function
    observations: u64, // one read of the observation
    comparisons: u64,  // one comparison of two signatures
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
            transitions: self.transitions - o.transitions,
            observations: self.observations - o.observations,
            comparisons: self.comparisons - o.comparisons,
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

// ---------------------------------------------------------------- domains
//
// A domain is GENERATED from constructors, never written down as a table.

#[derive(Clone)]
struct Domain {
    name: String,
    n_states: usize,
    n_actions: usize,
    delta: Vec<usize>, // delta[state * n_actions + action]
    obs: Vec<u8>,
    seed: usize,
    // action a of index i >= n_primitive is a macro: expansion[i - n_primitive]
    n_primitive: usize,
    expansions: Vec<Vec<usize>>,
}

impl Domain {
    fn step(&self, k: &mut Kernel, s: usize, a: usize) -> usize {
        k.s.transitions += 1;
        self.delta[s * self.n_actions + a]
    }
    fn observe(&self, k: &mut Kernel, s: usize) -> u8 {
        k.s.observations += 1;
        self.obs[s]
    }
    /// FutureBehavior.run
    fn run(&self, k: &mut Kernel, mut s: usize, w: &[usize]) -> usize {
        for &a in w {
            s = self.step(k, s, a);
        }
        s
    }

    /// Divisibility crystal: states are residues mod m, the base-b digit d acts
    /// by r |-> b*r + d, and the observation is "is the residue zero".
    /// (notes/MATHEMATICS_THAT_LEARNS.md, notes/BINARY_DIVISIBILITY_CRYSTAL.md)
    fn divisibility(base: usize, modulus: usize) -> Domain {
        let mut delta = vec![0usize; modulus * base];
        for r in 0..modulus {
            for d in 0..base {
                delta[r * base + d] = (base * r + d) % modulus;
            }
        }
        Domain {
            name: format!("divisibility(base {}, modulus {})", base, modulus),
            n_states: modulus,
            n_actions: base,
            delta,
            obs: (0..modulus).map(|r| (r == 0) as u8).collect(),
            seed: 0,
            n_primitive: base,
            expansions: vec![],
        }
    }

    /// Install a macro: one new action whose transition table is the composite
    /// of the block. The composite is built by literally composing the block on
    /// every state, so the installed action is EQUAL to the block by finite
    /// exhaustive construction -- not by assertion. (CLAUDE.md: a finite
    /// exhaustive verification is proof.)
    fn install_macro(&self, k: &mut Kernel, block: &[usize]) -> Domain {
        let mut d = self.clone();
        let old_a = self.n_actions;
        let new_a = old_a + 1;
        let mut delta = vec![0usize; self.n_states * new_a];
        for s in 0..self.n_states {
            for a in 0..old_a {
                delta[s * new_a + a] = self.delta[s * old_a + a];
            }
            delta[s * new_a + old_a] = self.run(k, s, block);
        }
        d.n_actions = new_a;
        d.delta = delta;
        d.expansions.push(block.to_vec());
        d
    }

    /// Adjoin one affine action r |-> a*r + c mod n_states as a new generator.
    fn adjoin_affine(&self, a_mul: usize, c: usize) -> Domain {
        let mut d = self.clone();
        let old_a = self.n_actions;
        let new_a = old_a + 1;
        let mut delta = vec![0usize; self.n_states * new_a];
        for s in 0..self.n_states {
            for a in 0..old_a {
                delta[s * new_a + a] = self.delta[s * old_a + a];
            }
            delta[s * new_a + old_a] = (a_mul * s + c) % self.n_states;
        }
        d.n_actions = new_a;
        d.delta = delta;
        d
    }

    /// Replay law: running the macro equals running its expansion, on every
    /// state. Checked exhaustively at install time; this is the executable form
    /// of KuttakaValli.replayHom's monoid-morphism property.
    fn macro_replay_holds(&self, k: &mut Kernel, macro_action: usize) -> bool {
        let exp = &self.expansions[macro_action - self.n_primitive].clone();
        for s in 0..self.n_states {
            let a = self.step(k, s, macro_action);
            let b = self.run(k, s, exp);
            k.s.comparisons += 1;
            if a != b {
                return false;
            }
        }
        true
    }
}

// ---------------------------------------------------------------- GENERATE

fn generate(k: &mut Kernel, d: &Domain) -> Vec<usize> {
    let mut seen = vec![false; d.n_states];
    let mut order = Vec::new();
    let mut queue = vec![d.seed];
    seen[d.seed] = true;
    order.push(d.seed);
    while let Some(s) = queue.pop() {
        for a in 0..d.n_primitive {
            let t = d.step(k, s, a);
            k.s.comparisons += 1;
            if !seen[t] {
                seen[t] = true;
                order.push(t);
                queue.push(t);
            }
        }
    }
    order
}

// ------------------------------------------------------------- DISTINGUISH
//
// Moore refinement. The fixed point is Myhill-Nerode / FutureEq: two states are
// merged exactly when no word of any length separates their observations.
// Soundness of that identification is FutureBehavior.futureEq_iff_behavior_eq;
// what is measured here is what it costs.

struct Partition {
    class_of: Vec<usize>,
    n_classes: usize,
    rounds: usize,
}

fn distinguish(k: &mut Kernel, d: &Domain, live: &[usize]) -> Partition {
    let mut class_of = vec![0usize; d.n_states];
    for &s in live {
        class_of[s] = d.observe(k, s) as usize;
    }
    let mut n_classes = 2;
    let mut rounds = 0;
    loop {
        rounds += 1;
        // signature = (current class, classes of the images under each action)
        let mut sigs: Vec<(Vec<usize>, usize)> = Vec::new();
        let mut next = vec![0usize; d.n_state_slots()];
        for &s in live {
            let mut sig = Vec::with_capacity(1 + d.n_primitive);
            sig.push(class_of[s]);
            for a in 0..d.n_primitive {
                let t = d.step(k, s, a);
                sig.push(class_of[t]);
            }
            let mut found = None;
            for (i, (other, _)) in sigs.iter().enumerate() {
                k.s.comparisons += 1;
                if *other == sig {
                    found = Some(i);
                    break;
                }
            }
            let id = match found {
                Some(i) => sigs[i].1,
                None => {
                    let id = sigs.len();
                    sigs.push((sig, id));
                    id
                }
            };
            next[s] = id;
        }
        let new_n = sigs.len();
        k.s.comparisons += 1;
        if new_n == n_classes {
            return Partition { class_of, n_classes, rounds };
        }
        n_classes = new_n;
        class_of = next;
    }
}

impl Domain {
    fn n_state_slots(&self) -> usize {
        self.n_states
    }
}

/// BehavioralBFS.shortestDistinguishingUpTo: the shortest word separating two
/// states, or None within the bound. Minimality is the checked half; the length
/// is what the machine records as the price of the distinction.
fn shortest_separating(
    k: &mut Kernel,
    d: &Domain,
    x: usize,
    y: usize,
    bound: usize,
) -> Option<Vec<usize>> {
    let mut frontier = vec![(x, y, Vec::new())];
    let mut seen = vec![false; d.n_states * d.n_states];
    seen[x * d.n_states + y] = true;
    for _ in 0..=bound {
        let mut nxt = Vec::new();
        for (p, q, w) in frontier {
            let op = d.observe(k, p);
            let oq = d.observe(k, q);
            k.s.comparisons += 1;
            if op != oq {
                return Some(w);
            }
            for a in 0..d.n_primitive {
                let p2 = d.step(k, p, a);
                let q2 = d.step(k, q, a);
                let idx = p2 * d.n_states + q2;
                k.s.comparisons += 1;
                if !seen[idx] {
                    seen[idx] = true;
                    let mut w2 = w.clone();
                    w2.push(a);
                    nxt.push((p2, q2, w2));
                }
            }
        }
        if nxt.is_empty() {
            return None;
        }
        frontier = nxt;
    }
    None
}

// ------------------------------------------------------------- CRYSTALLIZE
//
// Mine the most-reused contiguous action block across a corpus of derivations,
// then install it iff it strictly pays under the exact syntax measure of
// notes/KUTTAKA_TRACE_MACRO.md: a block of length m reused r times has
// expanded length m*r, installed length m+r, gain (m-1)(r-1)-1.

struct Mined {
    block: Vec<usize>,
    reuse: usize,
    gain: i64,
}

fn crystallize(words: &[Vec<usize>], max_len: usize) -> Option<Mined> {
    let mut best: Option<Mined> = None;
    for m in 2..=max_len {
        let mut cands: Vec<(Vec<usize>, usize)> = Vec::new();
        for w in words {
            if w.len() < m {
                continue;
            }
            for i in 0..=(w.len() - m) {
                let b = w[i..i + m].to_vec();
                match cands.iter_mut().find(|(c, _)| *c == b) {
                    Some((_, n)) => *n += 1,
                    None => cands.push((b, 1)),
                }
            }
        }
        for (b, r) in cands {
            let gain = (m as i64 - 1) * (r as i64 - 1) - 1;
            if gain > 0 {
                let better = match &best {
                    None => true,
                    Some(x) => gain > x.gain,
                };
                if better {
                    best = Some(Mined { block: b, reuse: r, gain });
                }
            }
        }
    }
    best
}

// ------------------------------------------------------------------ ROUTE
//
// A query asks, for a digit word w, which seeds end in the accepting class.
// Answering it directly costs one pass per live state; answering it on the
// installed quotient costs one pass per class. Installation is chosen by
// horizon, never by preference.

fn query_direct(k: &mut Kernel, d: &Domain, live: &[usize], w: &[usize]) -> usize {
    let mut acc = 0;
    for &s in live {
        let t = d.run(k, s, w);
        let o = d.observe(k, t);
        k.s.comparisons += 1;
        if o == 1 {
            acc += 1;
        }
    }
    acc
}

fn quotient_domain(k: &mut Kernel, d: &Domain, live: &[usize], p: &Partition) -> Domain {
    // FutureBehavior.quotientStep: well defined because FutureEq is a congruence.
    let n = p.n_classes;
    let mut delta = vec![usize::MAX; n * d.n_actions];
    let mut obs = vec![0u8; n];
    for &s in live {
        let c = p.class_of[s];
        obs[c] = d.observe(k, s);
        for a in 0..d.n_actions {
            let t = d.step(k, s, a);
            delta[c * d.n_actions + a] = p.class_of[t];
        }
    }
    Domain {
        name: format!("{} / FutureEq", d.name),
        n_states: n,
        n_actions: d.n_actions,
        delta,
        obs,
        seed: p.class_of[d.seed],
        n_primitive: d.n_primitive,
        expansions: d.expansions.clone(),
    }
}

// ----------------------------------------------------------------- REOPEN
//
// An installed compression is sound for an admitted action A exactly while A
// preserves the installed carrier. When it does not, there are two prices, and
// they are not the same price:
//
//   one-step  : distinctions forced by applying A once
//   persistent: distinctions forced by the closure under all future uses of A
//
// notes/LEAKAGE_PAST_IDEMPOTENCE.md Theorem C proves one-step is exact in the
// two-sector case and a strict undercount past it; the machine therefore quotes
// BOTH and flags the gap rather than quoting the cheaper one.

struct Reopening {
    one_step: usize,
    persistent: usize,
}

fn reopen(k: &mut Kernel, d: &Domain, live: &[usize], p: &Partition, new_action: usize) -> Reopening {
    // one-step: refine the installed partition by the class of the A-image.
    let mut sigs: Vec<(usize, usize)> = Vec::new();
    for &s in live {
        let t = d.step(k, s, new_action);
        let sig = (p.class_of[s], p.class_of[t]);
        k.s.comparisons += 1;
        if !sigs.contains(&sig) {
            sigs.push(sig);
        }
    }
    let one_step = sigs.len() - p.n_classes;

    // persistent: the least refinement closed under the new action as well,
    // i.e. re-run DISTINGUISH with the action admitted.
    let mut d2 = d.clone();
    d2.n_primitive = d.n_primitive.max(new_action + 1);
    let closed = distinguish(k, &d2, live);
    let persistent = closed.n_classes - p.n_classes;

    Reopening { one_step, persistent }
}

// ------------------------------------------------------------------- main

fn banner(out: &mut String, t: &str) {
    let _ = writeln!(out, "\n=== {}", t);
}

fn show(out: &mut String, label: &str, s: Steps) {
    let _ = writeln!(
        out,
        "    {:<42} transitions {:>8}  observations {:>8}  comparisons {:>8}  total {:>9}",
        label, s.transitions, s.observations, s.comparisons, s.total()
    );
}

fn main() {
    let mut out = String::new();
    let k = &mut Kernel::new();

    let _ = writeln!(&mut out, "natural machine -- cpu loop, exact integers, no model in the loop");

    // ---------------- GENERATE + DISTINGUISH on the home domain
    banner(&mut out, "GENERATE");
    let home = Domain::divisibility(2, 12);
    let m0 = k.mark();
    let live = generate(k, &home);
    let _ = writeln!(&mut out, "    {} -> {} reachable states", home.name, live.len());
    show(&mut out, "generation", k.since(m0));

    banner(&mut out, "DISTINGUISH");
    let m1 = k.mark();
    let part = distinguish(k, &home, &live);
    let _ = writeln!(
        &mut out,
        "    {} states collapse to {} classes in {} rounds",
        live.len(),
        part.n_classes,
        part.rounds
    );
    let _ = writeln!(
        &mut out,
        "    installed law (proved, not measured): base 2, m = 2^a q with q odd needs q + a states."
    );
    let _ = writeln!(
        &mut out,
        "    m = 12 = 2^2 * 3, so q + a = 3 + 2 = 5.   machine found {}   agree: {}",
        part.n_classes,
        part.n_classes == 5
    );
    show(&mut out, "refinement", k.since(m1));

    // shortest separating witnesses: the price of each distinction
    let mut witness_words: Vec<Vec<usize>> = Vec::new();
    let mut reps: Vec<usize> = Vec::new();
    for &s in &live {
        if !reps.iter().any(|&r| part.class_of[r] == part.class_of[s]) {
            reps.push(s);
        }
    }
    let m2 = k.mark();
    for i in 0..reps.len() {
        for j in (i + 1)..reps.len() {
            if let Some(w) = shortest_separating(k, &home, reps[i], reps[j], 8) {
                witness_words.push(w);
            }
        }
    }
    let _ = writeln!(
        &mut out,
        "    {} shortest separating witnesses retained (BehavioralBFS.shortestDistinguishingUpTo)",
        witness_words.len()
    );
    show(&mut out, "witness search", k.since(m2));

    // ---------------- ROUTE: direct vs compiled, decided by horizon
    banner(&mut out, "ROUTE");
    let workload: Vec<Vec<usize>> = vec![
        vec![1, 0, 1, 1, 0, 1, 1, 0, 1],
        vec![0, 1, 1, 0, 1, 1, 0, 1, 1],
        vec![1, 1, 0, 1, 1, 0, 1, 1, 0],
        vec![1, 0, 1, 1, 0, 1, 0, 1, 1],
    ];
    let m3 = k.mark();
    for w in &workload {
        query_direct(k, &home, &live, w);
    }
    let direct = k.since(m3);
    show(&mut out, "workload, direct route", direct);

    let m4 = k.mark();
    let quo = quotient_domain(k, &home, &live, &part);
    let compile_cost = k.since(m4);
    let qlive: Vec<usize> = (0..quo.n_states).collect();
    let m5 = k.mark();
    for w in &workload {
        query_direct(k, &quo, &qlive, w);
    }
    let compiled = k.since(m5);
    show(&mut out, "one-time compilation", compile_cost);
    show(&mut out, "workload, compiled route", compiled);
    let _ = writeln!(
        &mut out,
        "    horizon {} queries: direct {} vs compile+run {} -> install: {}",
        workload.len(),
        direct.total(),
        compile_cost.total() + compiled.total(),
        direct.total() > compile_cost.total() + compiled.total()
    );

    // ---------------- CRYSTALLIZE
    banner(&mut out, "CRYSTALLIZE");
    let mut corpus = witness_words.clone();
    corpus.extend(workload.iter().cloned());
    match crystallize(&corpus, 4) {
        None => {
            let _ = writeln!(&mut out, "    no block earns installation");
        }
        Some(mined) => {
            let _ = writeln!(
                &mut out,
                "    mined block {:?}, reused {} times, syntax gain (m-1)(r-1)-1 = {} > 0 -> install",
                mined.block, mined.reuse, mined.gain
            );
            let m6 = k.mark();
            let with_macro = home.install_macro(k, &mined.block);
            let macro_id = with_macro.n_actions - 1;
            let ok = with_macro.macro_replay_holds(k, macro_id);
            let _ = writeln!(
                &mut out,
                "    replay law checked exhaustively on all {} states: {}",
                with_macro.n_states, ok
            );
            show(&mut out, "install + exhaustive replay check", k.since(m6));

            // ------------- SEED CRITERION on an INDEPENDENT problem
            banner(&mut out, "SEED CRITERION (independent problem)");
            let indep = Domain::divisibility(2, 35); // different modulus, odd, not an instance
            let mi = k.mark();
            let ilive = generate(k, &indep);
            let _ = k.since(mi);
            // The independent workload is fixed in advance and is NOT built from
            // the mined block: the binary expansions of four constants chosen
            // before the block was known. Whatever reduction appears is whatever
            // the block happens to be worth on unseen input.
            let iwork: Vec<Vec<usize>> =
                [1000u64, 12345, 65535, 99991].iter().map(|&n| bits(n)).collect();
            let folds: usize = iwork
                .iter()
                .map(|w| w.len() - fold_with(w, &mined.block, 0).len())
                .sum::<usize>()
                / (mined.block.len() - 1).max(1);
            let m7 = k.mark();
            for w in &iwork {
                query_direct(k, &indep, &ilive, w);
            }
            let before = k.since(m7);

            let m8 = k.mark();
            let indep_macro = indep.install_macro(k, &mined.block);
            let ok2 = indep_macro.macro_replay_holds(k, indep_macro.n_actions - 1);
            let transport = k.since(m8);
            let mid = indep_macro.n_actions - 1;
            let m9 = k.mark();
            for w in &iwork {
                let folded = fold_with(w, &mined.block, mid);
                query_direct(k, &indep_macro, &ilive, &folded);
            }
            let after = k.since(m9);

            let _ = writeln!(&mut out, "    independent problem: {}", indep.name);
            let _ = writeln!(
                &mut out,
                "    workload = binary expansions of 1000, 12345, 65535, 99991 (fixed in advance,"
            );
            let _ = writeln!(
                &mut out,
                "    not built from the block); the block occurs in them {} times",
                folds
            );
            let _ = writeln!(&mut out, "    replay law re-checked on transport: {}", ok2);
            show(&mut out, "before installation", before);
            show(&mut out, "transport of the installed fact", transport);
            show(&mut out, "after installation", after);
            let saved = before.total() as i64 - after.total() as i64;
            let _ = writeln!(
                &mut out,
                "    strictly fewer kernel steps on the workload: {}   ({} -> {}, saved {})",
                after.total() < before.total(),
                before.total(),
                after.total(),
                saved
            );
            let _ = writeln!(
                &mut out,
                "    but installation is not free: transport cost {}.",
                transport.total()
            );
            let pays = saved > transport.total() as i64;
            let _ = writeln!(
                &mut out,
                "    SEED CRITERION (cost strictly lower INCLUDING installation): {}",
                pays
            );
            if !pays {
                let need = (transport.total() as i64 + saved - 1) / saved.max(1);
                let _ = writeln!(
                    &mut out,
                    "    it pays only from {} repetitions of this workload onward; at one pass it does NOT.",
                    need
                );
                let _ = writeln!(
                    &mut out,
                    "    This is FAILURES.md F32 reproduced by the machine on itself: a true theorem"
                );
                let _ = writeln!(
                    &mut out,
                    "    (the exhaustively checked replay law) is not automatically a capability."
                );
                let _ = writeln!(
                    &mut out,
                    "    It is also KUTTAKA_TRACE_MACRO's threshold: reuse on UNSEEN input was 1."
                );
            }

            // ------------- NULL CONTROL
            banner(&mut out, "NULL CONTROL");
            // A genuine null control must be a fact that is IRRELEVANT to the
            // independent problem, so it is searched for, not assumed: the
            // shortest block of the same alphabet with zero occurrences in the
            // workload. [0,0,0] would NOT do -- it occurs in these words.
            let null_block = absent_block(&iwork).expect("no absent block found");
            let null_dom = indep.install_macro(k, &null_block);
            let nid = null_dom.n_actions - 1;
            let m10 = k.mark();
            for w in &iwork {
                let folded = fold_with(w, &null_block, nid);
                query_direct(k, &null_dom, &ilive, &folded);
            }
            let null_after = k.since(m10);
            let _ = writeln!(
                &mut out,
                "    unrelated block {:?} installed; workload cost {} vs baseline {}",
                null_block,
                null_after.total(),
                before.total()
            );
            let _ = writeln!(
                &mut out,
                "    MUST NOT REDUCE: {}",
                null_after.total() >= before.total()
            );
        }
    }

    // ---------------- REOPEN
    banner(&mut out, "REOPEN");
    // Exhaustive finite classification, not one hand-picked example: admit each
    // affine action r |-> a*r + c mod m in turn and price it both ways.
    let m11 = k.mark();
    let m = home.n_states;
    let mut sound = 0usize;
    let mut reopened = 0usize;
    let mut gapped: Vec<(usize, usize, usize, usize)> = Vec::new(); // a,c,one,persistent
    for a_mul in 0..m {
        for c in 0..m {
            let widened = home.adjoin_affine(a_mul, c);
            let r = reopen(k, &widened, &live, &part, home.n_actions);
            if r.persistent == 0 {
                sound += 1;
            } else {
                reopened += 1;
                if r.persistent > r.one_step {
                    gapped.push((a_mul, c, r.one_step, r.persistent));
                }
            }
        }
    }
    show(&mut out, "exhaustive reopening classification", k.since(m11));
    let _ = writeln!(
        &mut out,
        "    all {} affine actions r |-> a*r+c mod {} priced against the installed {}-class carrier",
        m * m,
        m,
        part.n_classes
    );
    let _ = writeln!(
        &mut out,
        "    sound (no correction needed): {}     reopening: {}",
        sound, reopened
    );
    let _ = writeln!(
        &mut out,
        "    of the reopening actions, {} have persistent > one-step, i.e. the one-step price is WRONG",
        gapped.len()
    );
    // deterministic tie-break: maximal gap, then lexicographically least (a,c)
    let maxgap = gapped.iter().map(|t| t.3 - t.2).max().unwrap_or(0);
    let n_maximal = gapped.iter().filter(|t| t.3 - t.2 == maxgap).count();
    if let Some(&(a_mul, c, one, per)) = gapped.iter().find(|t| t.3 - t.2 == maxgap) {
        let _ = writeln!(
            &mut out,
            "    maximal gap {} attained by {} of them; least witness reported:",
            maxgap, n_maximal
        );
        let _ = writeln!(
            &mut out,
            "    extremal witness: r |-> {}r + {} mod {}   one-step {}   persistent {}   gap {}",
            a_mul, c, m, one, per, per - one
        );
        let _ = writeln!(
            &mut out,
            "    a machine quoting the one-step rank underprices this compression by {} distinctions",
            per - one
        );
    }
    let _ = writeln!(
        &mut out,
        "    (LEAKAGE_PAST_IDEMPOTENCE Thm C: one-step is exact in the two-sector case and a"
    );
    let _ = writeln!(
        &mut out,
        "     strict lower bound past it; the machine therefore quotes both, never the cheaper one)"
    );

    banner(&mut out, "TOTAL");
    show(&mut out, "whole run", k.mark());

    print!("{}", out);
}

/// Shortest binary block occurring nowhere in the workload. Searched, not
/// assumed: a control that secretly occurs is not a control.
fn absent_block(words: &[Vec<usize>]) -> Option<Vec<usize>> {
    for len in 2..=12 {
        for mask in 0u32..(1u32 << len) {
            let b: Vec<usize> = (0..len).map(|i| ((mask >> (len - 1 - i)) & 1) as usize).collect();
            let occurs = words.iter().any(|w| {
                w.len() >= len && (0..=(w.len() - len)).any(|i| w[i..i + len] == b[..])
            });
            if !occurs {
                return Some(b);
            }
        }
    }
    None
}

/// Big-endian binary expansion, as a digit word for the base-2 crystal.
fn bits(mut n: u64) -> Vec<usize> {
    if n == 0 {
        return vec![0];
    }
    let mut v = Vec::new();
    while n > 0 {
        v.push((n & 1) as usize);
        n >>= 1;
    }
    v.reverse();
    v
}

/// Replace every occurrence of `block` by the single macro action `id`.
/// Semantics are preserved by the exhaustively checked replay law.
fn fold_with(w: &[usize], block: &[usize], id: usize) -> Vec<usize> {
    let mut out = Vec::new();
    let mut i = 0;
    while i < w.len() {
        if i + block.len() <= w.len() && &w[i..i + block.len()] == block {
            out.push(id);
            i += block.len();
        } else {
            out.push(w[i]);
            i += 1;
        }
    }
    out
}
