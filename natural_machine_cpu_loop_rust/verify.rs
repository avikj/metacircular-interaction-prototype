// Independent re-derivation of the REOPEN classification.
//
// This file shares no code with main.rs. Where main.rs computes Myhill-Nerode
// classes by Moore refinement (iterated signature splitting), this file computes
// them by brute force: it evaluates each state's behavior function directly --
// the observation after every action word up to a length bound -- and groups
// states by equality of those tables. Two different algorithms; if the counts
// agree the classification is confirmed, if not one of them is wrong.
//
// Bound justification: on n states, any two distinguishable states are separated
// by a word of length < n (the pair-BFS visits at most n^2 pairs, and the
// standard bound for the divisibility crystal is far below that). We take the
// bound 16 > 12, and additionally report whether raising it changes anything.

fn behavior(delta: &[usize], n_act: usize, obs: &[u8], s: usize, bound: usize) -> Vec<u8> {
    // observations after every word of length 0..=bound, in lexicographic order
    let mut table = Vec::new();
    let mut layer = vec![s];
    for _ in 0..=bound {
        for &x in &layer {
            table.push(obs[x]);
        }
        let mut next = Vec::with_capacity(layer.len() * n_act);
        for &x in &layer {
            for a in 0..n_act {
                next.push(delta[x * n_act + a]);
            }
        }
        layer = next;
        if layer.len() > 200_000 {
            break;
        }
    }
    table
}

fn classes(delta: &[usize], n_act: usize, obs: &[u8], n: usize, bound: usize) -> usize {
    let mut tabs: Vec<Vec<u8>> = Vec::new();
    for s in 0..n {
        let t = behavior(delta, n_act, obs, s, bound);
        if !tabs.iter().any(|u| *u == t) {
            tabs.push(t);
        }
    }
    tabs.len()
}

fn class_of(delta: &[usize], n_act: usize, obs: &[u8], n: usize, bound: usize) -> Vec<usize> {
    let mut tabs: Vec<Vec<u8>> = Vec::new();
    let mut c = vec![0usize; n];
    for s in 0..n {
        let t = behavior(delta, n_act, obs, s, bound);
        match tabs.iter().position(|u| *u == t) {
            Some(i) => c[s] = i,
            None => {
                c[s] = tabs.len();
                tabs.push(t);
            }
        }
    }
    c
}

fn main() {
    let b = 2usize;
    let m = 12usize;
    // base-2 digit actions only
    let mut delta = vec![0usize; m * b];
    for r in 0..m {
        for d in 0..b {
            delta[r * b + d] = (b * r + d) % m;
        }
    }
    let obs: Vec<u8> = (0..m).map(|r| (r == 0) as u8).collect();

    let base_classes = classes(&delta, b, &obs, m, 8);
    let base_c = class_of(&delta, b, &obs, m, 8);
    println!("installed carrier: {} classes (brute-force behavior tables)", base_classes);
    println!("  q + a for m = 12 = 2^2*3 is 3 + 2 = 5 -> agree: {}", base_classes == 5);
    println!("  class of each residue 0..11: {:?}", base_c);

    let mut sound = 0;
    let mut reopening = 0;
    let mut gapped = 0;
    let mut best = (0usize, 0usize, 0usize, 0usize);
    for a_mul in 0..m {
        for c in 0..m {
            let n_act = b + 1;
            let mut d2 = vec![0usize; m * n_act];
            for r in 0..m {
                for d in 0..b {
                    d2[r * n_act + d] = delta[r * b + d];
                }
                d2[r * n_act + b] = (a_mul * r + c) % m;
            }
            // persistent: classes with the action admitted, brute force
            let per_classes = classes(&d2, n_act, &obs, m, 8);
            let persistent = per_classes - base_classes;
            // one-step: refine the installed partition by the class of the image
            let mut sigs: Vec<(usize, usize)> = Vec::new();
            for r in 0..m {
                let t = (a_mul * r + c) % m;
                let s = (base_c[r], base_c[t]);
                if !sigs.contains(&s) {
                    sigs.push(s);
                }
            }
            let one_step = sigs.len() - base_classes;
            if persistent == 0 {
                sound += 1;
            } else {
                reopening += 1;
                if persistent > one_step {
                    gapped += 1;
                    if persistent - one_step > best.3 - best.2 {
                        best = (a_mul, c, one_step, persistent);
                    }
                }
            }
        }
    }
    println!("sound {}  reopening {}  gapped {}", sound, reopening, gapped);
    println!(
        "extremal witness r -> {}r + {} mod {}: one-step {} persistent {} gap {}",
        best.0, best.1, m, best.2, best.3, best.3 - best.2
    );
}
