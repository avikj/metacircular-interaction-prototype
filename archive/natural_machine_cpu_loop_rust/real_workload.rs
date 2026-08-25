// The machine, on mathematics this repository actually cares about.
//
// The workload is no longer a toy. It is the exclusion method the prime-prefix
// factor program actually uses, run on the actual objects:
//
//     F_X(x) = sum_{p <= X} x^{p-2}          (p prime)
//
// The corpus closed factor degrees 4 through 9 for these polynomials
// (notes/NONIC_OBSTRUCTION.md and its predecessors), leaving the nonreciprocal
// DEGREE TEN layer as the first open frontier (notes/FACTOR_ARCHITECTURE.md,
// notes/NONRECIPROCAL_DECIC_FRONTIER.md). The exclusion certificates it used are
// modular: "754 modular irreducibility witnesses ... exact prefix/tail
// certificates by q <= 41".
//
// THE CERTIFICATE, stated exactly, because the machine must not be trusted to
// mean something vague by it:
//
//   If g divides F_X over Z with deg g = d, then reducing mod a prime q of good
//   reduction, g mod q divides F_X mod q. Hence the multiset D_q(X) of degrees
//   of the irreducible factors of F_X over F_q must contain a sub-multiset
//   summing to d. Contrapositive, and this is what the machine computes:
//
//       if no sub-multiset of D_q(X) sums to d, then F_X has NO factor of
//       degree d over Z.
//
//   One prime q suffices. This is a proof, not evidence: it is exact finite
//   computation in F_q[x], and CLAUDE.md admits exactly that as proof.
//
// The machine's task per object: find such a certifying q for d = 10, as cheaply
// as possible, counting exact kernel operations.
//
// The learning: WHICH primes certify. Nothing says the small primes are equally
// good, and the corpus's own certificates ran to q <= 83 in some degrees and
// q <= 41 in others without anyone asking why. The machine ranks primes by
// measured success on the F_X it has already met, and applies that ranking to
// F_X it has not. That ordering is the transferable knowledge, and whether it
// transfers is the falsifiable claim.
//
// Exact integers throughout. No floating point. No model in the loop.
//
//   rustc -O real_workload.rs -o real_workload && ./real_workload

// ------------------------------------------------------------ kernel counter

#[derive(Default, Clone, Copy)]
struct Steps {
    mulmod: u64,   // one multiplication in F_q
    polyop: u64,   // one polynomial coefficient touch
    gcdstep: u64,  // one Euclidean step on polynomials
}
impl Steps {
    fn total(&self) -> u64 {
        self.mulmod + self.polyop + self.gcdstep
    }
}
struct Kernel {
    s: Steps,
}
impl Kernel {
    fn new() -> Kernel {
        Kernel { s: Steps::default() }
    }
    fn total(&self) -> u64 {
        self.s.total()
    }
}

// ---------------------------------------------------------------- primes

fn primes_upto(n: usize) -> Vec<usize> {
    let mut sieve = vec![true; n + 1];
    let mut out = vec![];
    for i in 2..=n {
        if sieve[i] {
            out.push(i);
            let mut j = i * i;
            while j <= n {
                sieve[j] = false;
                j += i;
            }
        }
    }
    out
}

/// F_X as a coefficient vector over Z, ascending powers. Coefficients are 0/1;
/// the exponents are p-2 over primes p <= X. Note F_2 contributes x^0.
fn prime_prefix_poly(x_limit: usize, primes: &[usize]) -> Vec<i64> {
    let ps: Vec<usize> = primes.iter().cloned().filter(|&p| p <= x_limit).collect();
    let top = ps.last().copied().unwrap_or(2) - 2;
    let mut c = vec![0i64; top + 1];
    for &p in &ps {
        c[p - 2] = 1;
    }
    c
}

// ------------------------------------------------- polynomial arithmetic mod q
// Dense, ascending powers, coefficients reduced mod q. Deliberately simple and
// auditable: the point is exactness and an honest operation count, not speed.

type Poly = Vec<u64>;

fn trim(a: &mut Poly) {
    while a.len() > 1 && *a.last().unwrap() == 0 {
        a.pop();
    }
}
fn deg(a: &Poly) -> usize {
    a.len() - 1
}
fn is_zero(a: &Poly) -> bool {
    a.len() == 1 && a[0] == 0
}

fn poly_mul(k: &mut Kernel, a: &Poly, b: &Poly, q: u64) -> Poly {
    let mut out = vec![0u64; a.len() + b.len() - 1];
    for (i, &x) in a.iter().enumerate() {
        if x == 0 {
            continue;
        }
        for (j, &y) in b.iter().enumerate() {
            k.s.mulmod += 1;
            out[i + j] = (out[i + j] + x * y) % q;
        }
    }
    trim(&mut out);
    out
}

fn poly_rem(k: &mut Kernel, a: &Poly, m: &Poly, q: u64) -> Poly {
    let mut r = a.clone();
    let dm = deg(m);
    if dm == 0 {
        return vec![0];
    }
    let lead_inv = inv_mod(m[dm], q);
    while deg(&r) >= dm && !is_zero(&r) {
        let d = deg(&r) - dm;
        k.s.mulmod += 1;
        let f = (r[deg(&r)] * lead_inv) % q;
        if f != 0 {
            for i in 0..=dm {
                k.s.polyop += 1;
                let sub = (f * m[i]) % q;
                let idx = i + d;
                r[idx] = (r[idx] + q - sub) % q;
            }
        }
        trim(&mut r);
        if deg(&r) < dm {
            break;
        }
        if r[deg(&r)] == 0 {
            break;
        }
    }
    trim(&mut r);
    r
}

fn poly_mulmod(k: &mut Kernel, a: &Poly, b: &Poly, m: &Poly, q: u64) -> Poly {
    let p = poly_mul(k, a, b, q);
    poly_rem(k, &p, m, q)
}

fn poly_sub(k: &mut Kernel, a: &Poly, b: &Poly, q: u64) -> Poly {
    let n = a.len().max(b.len());
    let mut out = vec![0u64; n];
    for i in 0..n {
        k.s.polyop += 1;
        let x = *a.get(i).unwrap_or(&0);
        let y = *b.get(i).unwrap_or(&0);
        out[i] = (x + q - y) % q;
    }
    trim(&mut out);
    out
}

fn poly_gcd(k: &mut Kernel, a: &Poly, b: &Poly, q: u64) -> Poly {
    let mut x = a.clone();
    let mut y = b.clone();
    while !is_zero(&y) {
        k.s.gcdstep += 1;
        let r = poly_rem(k, &x, &y, q);
        x = y;
        y = r;
    }
    // monic
    let d = deg(&x);
    if x[d] != 0 {
        let iv = inv_mod(x[d], q);
        for c in x.iter_mut() {
            k.s.mulmod += 1;
            *c = (*c * iv) % q;
        }
    }
    x
}

fn inv_mod(a: u64, q: u64) -> u64 {
    // q prime, Fermat
    let mut r = 1u64;
    let mut b = a % q;
    let mut e = q - 2;
    while e > 0 {
        if e & 1 == 1 {
            r = (r * b) % q;
        }
        b = (b * b) % q;
        e >>= 1;
    }
    r
}

/// a^e mod m in F_q[x]
fn poly_powmod(k: &mut Kernel, a: &Poly, e: u64, m: &Poly, q: u64) -> Poly {
    let mut result: Poly = vec![1];
    let mut base = poly_rem(k, a, m, q);
    let mut e = e;
    while e > 0 {
        if e & 1 == 1 {
            result = poly_mulmod(k, &result, &base, m, q);
        }
        base = poly_mulmod(k, &base, &base, m, q);
        e >>= 1;
    }
    result
}

// ------------------------------------------ distinct-degree factorization
//
// Returns the multiset of irreducible factor degrees of f over F_q, or None if
// f is not squarefree mod q / q divides the leading coefficient (bad reduction),
// in which case this q supplies no certificate and the machine moves on.

fn factor_degrees(k: &mut Kernel, f_in: &Poly, q: u64) -> Option<Vec<usize>> {
    let mut f = f_in.clone();
    trim(&mut f);
    if is_zero(&f) || deg(&f) == 0 {
        return None;
    }
    // squarefree check: gcd(f, f') must be 1
    let mut df = vec![0u64; f.len().saturating_sub(1).max(1)];
    for i in 1..f.len() {
        k.s.polyop += 1;
        df[i - 1] = (f[i] * (i as u64 % q)) % q;
    }
    trim(&mut df);
    if is_zero(&df) {
        return None;
    }
    let g = poly_gcd(k, &f, &df, q);
    if deg(&g) != 0 {
        return None; // not squarefree mod q; no certificate from this prime
    }

    let mut degrees = vec![];
    let mut h: Poly = poly_powmod(k, &vec![0, 1], q, &f, q); // x^q mod f
    let x: Poly = vec![0, 1];
    let mut d = 1usize;
    while deg(&f) >= 2 * d {
        let hx = poly_sub(k, &h, &x, q);
        let g = poly_gcd(k, &hx, &f, q);
        let dg = deg(&g);
        if dg > 0 {
            // g is the product of all irreducible factors of degree exactly d
            let count = dg / d;
            for _ in 0..count {
                degrees.push(d);
            }
            // f /= g
            f = poly_div_exact(k, &f, &g, q)?;
            h = poly_rem(k, &h, &f, q);
        }
        h = poly_powmod(k, &h, q, &f, q);
        d += 1;
    }
    if deg(&f) > 0 {
        degrees.push(deg(&f)); // remaining factor is irreducible
    }
    degrees.sort();
    Some(degrees)
}

fn poly_div_exact(k: &mut Kernel, a: &Poly, b: &Poly, q: u64) -> Option<Poly> {
    let db = deg(b);
    if db == 0 {
        return Some(a.clone());
    }
    let mut r = a.clone();
    let da = deg(a);
    if da < db {
        return None;
    }
    let mut out = vec![0u64; da - db + 1];
    let iv = inv_mod(b[db], q);
    while deg(&r) >= db && !is_zero(&r) {
        let d = deg(&r) - db;
        k.s.mulmod += 1;
        let f = (r[deg(&r)] * iv) % q;
        if f == 0 {
            break;
        }
        out[d] = f;
        for i in 0..=db {
            k.s.polyop += 1;
            let sub = (f * b[i]) % q;
            r[i + d] = (r[i + d] + q - sub) % q;
        }
        trim(&mut r);
    }
    trim(&mut out);
    Some(out)
}

/// Can any sub-multiset of `degs` sum to `target`? Exact subset-sum, small.
fn has_subset_sum(degs: &[usize], target: usize) -> bool {
    let mut reach = vec![false; target + 1];
    reach[0] = true;
    for &d in degs {
        if d > target {
            continue;
        }
        for t in (d..=target).rev() {
            if reach[t - d] {
                reach[t] = true;
            }
        }
    }
    reach[target]
}

// ------------------------------------------------------------------- the run

struct Attempt {
    certified: bool,
    cost: u64,
}

/// Try prime q as a certificate that F_X has no factor of degree `target`.
fn try_prime(f: &Poly, q: u64, target: usize) -> Attempt {
    let mut k = Kernel::new();
    let degs = factor_degrees(&mut k, f, q);
    let certified = match degs {
        None => false,
        Some(d) => !has_subset_sum(&d, target),
    };
    Attempt { certified, cost: k.total() }
}

fn main() {
    let target = 10usize; // the open frontier layer
    let primes = primes_upto(400);
    let candidate_qs: Vec<u64> = primes_upto(120).iter().map(|&p| p as u64).collect();

    // The objects: real F_X, one per prime X, in increasing order. No selection.
    let x_values: Vec<usize> = primes.iter().cloned().filter(|&p| p >= 13 && p <= 89).collect();

    println!("natural machine on a real workload");
    println!("  objects : F_X for X prime, 13 <= X <= 89   ({} polynomials)", x_values.len());
    println!("  task    : certify that F_X has NO factor of degree {} over Z,", target);
    println!("            by exhibiting one prime q whose mod-q factor degrees");
    println!("            admit no sub-multiset summing to {}", target);
    println!("  measure : exact operations in F_q[x]; no floating point anywhere");
    println!();

    // ---- arm A: fixed ascending prime order, the corpus's implicit default
    let mut cost_a = 0u64;
    let mut certified_a = 0usize;
    let mut per_object: Vec<(usize, Option<u64>, u64)> = vec![];
    for &x in &x_values {
        let f_z = prime_prefix_poly(x, &primes);
        let f: Poly = f_z.iter().map(|&c| c as u64).collect();
        let mut spent = 0u64;
        let mut winner = None;
        for &q in &candidate_qs {
            let a = try_prime(&f, q, target);
            spent += a.cost;
            if a.certified {
                winner = Some(q);
                break;
            }
        }
        if winner.is_some() {
            certified_a += 1;
        }
        cost_a += spent;
        per_object.push((x, winner, spent));
    }

    println!("  ARM A -- ascending primes (no learning)");
    println!("    certified {} of {} objects, {} kernel ops", certified_a, x_values.len(), cost_a);
    println!();
    println!("    X    certifying q    cost");
    for (x, w, c) in &per_object {
        match w {
            Some(q) => println!("    {:>3}   q = {:<8}  {:>10}", x, q, c),
            None => println!("    {:>3}   none <= 113  {:>10}", x, c),
        }
    }

    // ---- arm B: rank by SUCCESS RATE. This is the obvious thing and it is
    //      wrong; it is kept because being wrong is the finding. See arm C.
    let mut score: Vec<(u64, i64)> = candidate_qs.iter().map(|&q| (q, 0i64)).collect();
    let mut cost_b = 0u64;
    let mut certified_b = 0usize;
    let mut cost_b_second_half = 0u64;
    let half = x_values.len() / 2;
    for (i, &x) in x_values.iter().enumerate() {
        let f_z = prime_prefix_poly(x, &primes);
        let f: Poly = f_z.iter().map(|&c| c as u64).collect();
        // order: most successful first, ties by size
        let mut order: Vec<(u64, i64)> = score.clone();
        order.sort_by(|a, b| b.1.cmp(&a.1).then(a.0.cmp(&b.0)));
        let mut spent = 0u64;
        let mut got = false;
        for (q, _) in &order {
            let a = try_prime(&f, *q, target);
            spent += a.cost;
            if a.certified {
                if let Some(e) = score.iter_mut().find(|e| e.0 == *q) {
                    e.1 += 1;
                }
                got = true;
                break;
            } else if let Some(e) = score.iter_mut().find(|e| e.0 == *q) {
                e.1 -= 1;
            }
        }
        if got {
            certified_b += 1;
        }
        cost_b += spent;
        if i >= half {
            cost_b_second_half += spent;
        }
    }
    let cost_a_second_half: u64 = per_object[half..].iter().map(|(_, _, c)| c).sum();

    println!();
    println!("  ARM B -- the machine ranks primes by measured success and carries");
    println!("           the ranking to objects it has not met");
    println!("    certified {} of {} objects, {} kernel ops", certified_b, x_values.len(), cost_b);
    println!(
        "    total   : {} -> {}  ({:+.2}%)",
        cost_a,
        cost_b,
        100.0 * (cost_b as f64 - cost_a as f64) / cost_a as f64
    );
    println!(
        "    UNSEEN HALF: {} -> {}  ({:+.2}%)",
        cost_a_second_half,
        cost_b_second_half,
        100.0 * (cost_b_second_half as f64 - cost_a_second_half as f64) / cost_a_second_half as f64
    );
    println!();
    println!("  learned prime ranking (top 8 by net certifications):");
    let mut fin = score.clone();
    fin.sort_by(|a, b| b.1.cmp(&a.1));
    for (q, s) in fin.iter().take(8) {
        println!("    q = {:<5} net {:+}", q, s);
    }

    // ---- arm C: the machine revises its own objective.
    //
    // Arm B ranked by P(certify). The objective is not P(certify); it is the
    // EXPECTED COST TO THE FIRST CERTIFICATE. For a sequence of independent
    // tests with cost c_i and success probability p_i, the expected-cost-optimal
    // order is ascending in c_i / p_i (Smith's ratio rule). The machine now
    // estimates both quantities from what it has already run and orders by the
    // ratio, with Laplace smoothing so an untried prime is not starved.
    #[derive(Clone)]
    struct Stat {
        q: u64,
        cost_sum: u64,
        attempts: u64,
        successes: u64,
    }
    let mut stats: Vec<Stat> = candidate_qs
        .iter()
        .map(|&q| Stat { q, cost_sum: 0, attempts: 0, successes: 0 })
        .collect();
    let mut cost_c = 0u64;
    let mut certified_c = 0usize;
    let mut cost_c_second_half = 0u64;
    for (i, &x) in x_values.iter().enumerate() {
        let f_z = prime_prefix_poly(x, &primes);
        let f: Poly = f_z.iter().map(|&c| c as u64).collect();
        let mut order: Vec<Stat> = stats.clone();
        order.sort_by(|a, b| {
            // ratio = mean cost / smoothed success rate; untried primes get an
            // optimistic mean cost proportional to q, which is the only prior
            // available before any measurement
            let ra = if a.attempts == 0 {
                (a.q as f64) * 1000.0
            } else {
                (a.cost_sum as f64 / a.attempts as f64)
                    / ((a.successes as f64 + 1.0) / (a.attempts as f64 + 2.0))
            };
            let rb = if b.attempts == 0 {
                (b.q as f64) * 1000.0
            } else {
                (b.cost_sum as f64 / b.attempts as f64)
                    / ((b.successes as f64 + 1.0) / (b.attempts as f64 + 2.0))
            };
            ra.partial_cmp(&rb).unwrap().then(a.q.cmp(&b.q))
        });
        let mut spent = 0u64;
        let mut got = false;
        for s in &order {
            let a = try_prime(&f, s.q, target);
            spent += a.cost;
            if let Some(e) = stats.iter_mut().find(|e| e.q == s.q) {
                e.attempts += 1;
                e.cost_sum += a.cost;
                if a.certified {
                    e.successes += 1;
                }
            }
            if a.certified {
                got = true;
                break;
            }
        }
        if got {
            certified_c += 1;
        }
        cost_c += spent;
        if i >= half {
            cost_c_second_half += spent;
        }
    }

    println!();
    println!("  ARM C -- the machine revises its objective: rank by expected cost");
    println!("           to the first certificate (Smith's ratio rule), not by");
    println!("           probability of certifying");
    println!("    certified {} of {} objects, {} kernel ops", certified_c, x_values.len(), cost_c);
    println!(
        "    total   : {} -> {}  ({:+.2}%)",
        cost_a,
        cost_c,
        100.0 * (cost_c as f64 - cost_a as f64) / cost_a as f64
    );
    println!(
        "    UNSEEN HALF: {} -> {}  ({:+.2}%)",
        cost_a_second_half,
        cost_c_second_half,
        100.0 * (cost_c_second_half as f64 - cost_a_second_half as f64) / cost_a_second_half as f64
    );
    println!();
    // ---- arm D: the oracle. Knows the certifying prime in advance and pays
    //      only for it. This is the floor no policy can beat, and the gap
    //      between arm A and arm D is the entire room any learner has to work in.
    let mut cost_d = 0u64;
    for (x, w, _) in &per_object {
        if let Some(q) = w {
            let f_z = prime_prefix_poly(*x, &primes);
            let f: Poly = f_z.iter().map(|&c| c as u64).collect();
            cost_d += try_prime(&f, *q, target).cost;
        }
    }
    println!();
    println!("  ARM D -- oracle floor (knows the certifying prime, pays only for it)");
    println!("    {} kernel ops", cost_d);
    println!(
        "    room available to ANY learner: arm A {} - floor {} = {} ops ({:.1}% of A)",
        cost_a,
        cost_d,
        cost_a - cost_d,
        100.0 * (cost_a - cost_d) as f64 / cost_a as f64
    );
    println!("    cost of ONE exploratory attempt at the median prime, by contrast,");
    println!("    is on the order of the entire room -- which is why arms B and C lose.");

    println!();
    println!("  learned ratio ordering (top 6, cost per success):");
    let mut fc: Vec<&Stat> = stats.iter().filter(|s| s.attempts > 0).collect();
    fc.sort_by(|a, b| {
        let ra = (a.cost_sum as f64 / a.attempts as f64) / ((a.successes as f64 + 1.0) / (a.attempts as f64 + 2.0));
        let rb = (b.cost_sum as f64 / b.attempts as f64) / ((b.successes as f64 + 1.0) / (b.attempts as f64 + 2.0));
        ra.partial_cmp(&rb).unwrap()
    });
    for s in fc.iter().take(6) {
        println!(
            "    q = {:<4} attempts {:>3}  successes {:>3}  mean cost {:>9}",
            s.q,
            s.attempts,
            s.successes,
            s.cost_sum / s.attempts.max(1)
        );
    }
}
