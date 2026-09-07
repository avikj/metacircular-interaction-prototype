// Independent replay of the nineteen decic certificates, and an extension of the
// range as far as the CPU allows.
//
// TWO JOBS.
//
// (1) INDEPENDENCE. notes/DECIC_EXCLUSION_CERTIFICATES_AND_WHY_THE_MACHINE_
//     CANNOT_LEARN_HERE.md section 2 rests on one implementation. This file
//     shares no code with real_workload.rs and differs in method, not only in
//     spelling: it computes only the part of the factor-degree multiset that the
//     certificate can possibly use, and it decides the subset-sum by a bitmask
//     rather than a boolean table. Agreement on all nineteen is the replay.
//
// (2) THE ALGORITHMIC POINT THAT MAKES THE EXTENSION POSSIBLE, and it comes
//     straight out of the certificate rather than out of tuning:
//
//       A degree-ten divisor g of F_X over Z is monic (F_X is monic, so by
//       Gauss the factors are monic up to sign), so g mod q has degree exactly
//       10, and its irreducible factors over F_q have degrees that are POSITIVE
//       AND SUM TO 10 -- hence each is at most 10.
//
//     Therefore the certificate never consults any factor of F_X mod q of degree
//     above 10. The full distinct-degree factorization runs to degree n/2; this
//     one stops at 10. For F_X of degree n that replaces roughly n/2 Frobenius
//     steps by exactly 10, which is what turns X <= 89 into X in the hundreds.
//
//     This is FAILURES.md F32's lesson applied in the working direction: the
//     structure of the proof entered the algorithm, and the conclusion alone
//     would not have supplied it.
//
// Exact arithmetic in F_q[x]. No floating point. No model.
//
//   rustc -O decic_extend.rs -o decic_extend && ./decic_extend [X_MAX]

const TARGET: usize = 10;

fn primes_upto(n: usize) -> Vec<usize> {
    let mut s = vec![true; n + 1];
    let mut out = vec![];
    for i in 2..=n {
        if s[i] {
            out.push(i);
            let mut j = i * i;
            while j <= n {
                s[j] = false;
                j += i;
            }
        }
    }
    out
}

// ---------------------------------------------------- F_q[x], u64 coefficients

type P = Vec<u64>;

fn norm(a: &mut P) {
    while a.len() > 1 && *a.last().unwrap() == 0 {
        a.pop();
    }
}
fn dg(a: &P) -> usize {
    a.len() - 1
}
fn zero(a: &P) -> bool {
    a.len() == 1 && a[0] == 0
}

fn mulmod(a: &P, b: &P, m: &P, q: u64) -> P {
    // schoolbook then reduce; kept in one function so the reduction is never
    // accidentally skipped
    let mut t = vec![0u64; a.len() + b.len() - 1];
    for (i, &x) in a.iter().enumerate() {
        if x == 0 {
            continue;
        }
        for (j, &y) in b.iter().enumerate() {
            t[i + j] = (t[i + j] + x * y) % q;
        }
    }
    norm(&mut t);
    rem(&t, m, q)
}

fn rem(a: &P, m: &P, q: u64) -> P {
    let dm = dg(m);
    if dm == 0 {
        return vec![0];
    }
    let mut r = a.clone();
    norm(&mut r);
    let inv = pow_mod(m[dm], q - 2, q);
    while !zero(&r) && dg(&r) >= dm {
        let d = dg(&r) - dm;
        let f = (r[dg(&r)] * inv) % q;
        if f != 0 {
            for i in 0..=dm {
                let s = (f * m[i]) % q;
                r[i + d] = (r[i + d] + q - s) % q;
            }
        }
        let before = r.len();
        norm(&mut r);
        if r.len() == before {
            // leading coefficient failed to cancel: impossible over a field,
            // so this is a guard against a silent bug rather than a real branch
            break;
        }
    }
    norm(&mut r);
    r
}

fn pow_mod(mut b: u64, mut e: u64, q: u64) -> u64 {
    let mut r = 1u64;
    b %= q;
    while e > 0 {
        if e & 1 == 1 {
            r = (r * b) % q;
        }
        b = (b * b) % q;
        e >>= 1;
    }
    r
}

fn poly_pow(a: &P, e: u64, m: &P, q: u64) -> P {
    let mut r: P = vec![1];
    let mut b = rem(a, m, q);
    let mut e = e;
    while e > 0 {
        if e & 1 == 1 {
            r = mulmod(&r, &b, m, q);
        }
        b = mulmod(&b, &b, m, q);
        e >>= 1;
    }
    r
}

fn sub(a: &P, b: &P, q: u64) -> P {
    let n = a.len().max(b.len());
    let mut o = vec![0u64; n];
    for i in 0..n {
        let x = *a.get(i).unwrap_or(&0);
        let y = *b.get(i).unwrap_or(&0);
        o[i] = (x + q - y) % q;
    }
    norm(&mut o);
    o
}

fn gcd(a: &P, b: &P, q: u64) -> P {
    let mut x = a.clone();
    let mut y = b.clone();
    norm(&mut x);
    norm(&mut y);
    while !zero(&y) {
        let r = rem(&x, &y, q);
        x = y;
        y = r;
    }
    let d = dg(&x);
    if x[d] != 0 {
        let iv = pow_mod(x[d], q - 2, q);
        for c in x.iter_mut() {
            *c = (*c * iv) % q;
        }
    }
    x
}

fn deriv(a: &P, q: u64) -> P {
    if a.len() <= 1 {
        return vec![0];
    }
    let mut d = vec![0u64; a.len() - 1];
    for i in 1..a.len() {
        d[i - 1] = (a[i] * ((i as u64) % q)) % q;
    }
    norm(&mut d);
    d
}

/// Counts of irreducible factors of degree 1..=TARGET of f over F_q.
/// Returns None when q is a bad prime for this f (not squarefree mod q).
/// Stops at TARGET: no higher-degree factor can appear inside a degree-10
/// divisor, so the certificate cannot consult one.
fn low_degree_counts(f_in: &P, q: u64) -> Option<Vec<usize>> {
    let mut f = f_in.clone();
    norm(&mut f);
    if dg(&f) == 0 {
        return None;
    }
    let d1 = deriv(&f, q);
    if zero(&d1) {
        return None;
    }
    if dg(&gcd(&f, &d1, q)) != 0 {
        return None; // not squarefree mod q
    }

    let x: P = vec![0, 1];
    let mut h = poly_pow(&x, q, &f, q); // x^q mod f
    let mut counts = vec![0usize; TARGET + 1];
    for d in 1..=TARGET {
        if dg(&f) < 2 * d {
            // every remaining factor is irreducible of degree dg(f)
            break;
        }
        let g = gcd(&sub(&h, &x, q), &f, q);
        let dgg = dg(&g);
        if dgg > 0 {
            counts[d] = dgg / d;
            f = div_exact(&f, &g, q)?;
            h = rem(&h, &f, q);
        }
        h = poly_pow(&h, q, &f, q);
    }
    // whatever remains has all factors of degree > d reached, or is a single
    // irreducible; either way it cannot contribute a part of size <= TARGET that
    // we have not already counted, EXCEPT when the loop broke early because
    // dg(f) < 2d, in which case dg(f) itself is a factor degree.
    if dg(&f) > 0 && dg(&f) <= TARGET {
        counts[dg(&f)] += 1;
    }
    Some(counts)
}

fn div_exact(a: &P, b: &P, q: u64) -> Option<P> {
    let db = dg(b);
    if db == 0 {
        return Some(a.clone());
    }
    if dg(a) < db {
        return None;
    }
    let mut r = a.clone();
    let mut out = vec![0u64; dg(a) - db + 1];
    let iv = pow_mod(b[db], q - 2, q);
    while !zero(&r) && dg(&r) >= db {
        let d = dg(&r) - db;
        let f = (r[dg(&r)] * iv) % q;
        if f == 0 {
            break;
        }
        out[d] = f;
        for i in 0..=db {
            let s = (f * b[i]) % q;
            r[i + d] = (r[i + d] + q - s) % q;
        }
        norm(&mut r);
    }
    norm(&mut out);
    Some(out)
}

/// Bitmask subset-sum over a multiset given as counts[d] copies of d.
/// Bit t of the mask means "some sub-multiset sums to t".
fn reachable(counts: &[usize]) -> u32 {
    let mut mask: u32 = 1; // sum 0 reachable
    for d in 1..counts.len() {
        for _ in 0..counts[d] {
            mask |= mask << d;
            mask &= (1u32 << (TARGET + 1)) - 1;
        }
    }
    mask
}

fn f_x(x_limit: usize, primes: &[usize]) -> P {
    let ps: Vec<usize> = primes.iter().cloned().filter(|&p| p <= x_limit).collect();
    let top = ps.last().unwrap() - 2;
    let mut c = vec![0u64; top + 1];
    for &p in &ps {
        c[p - 2] = 1;
    }
    c
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let x_max: usize = args.get(1).and_then(|s| s.parse().ok()).unwrap_or(200);

    let primes = primes_upto(x_max + 10);
    let qs: Vec<u64> = primes_upto(60).iter().map(|&p| p as u64).collect();
    let xs: Vec<usize> = primes.iter().cloned().filter(|&p| p >= 13 && p <= x_max).collect();

    println!("decic exclusion, independent implementation, truncated at degree {}", TARGET);
    println!("  F_X has no degree-{} factor over Z iff some prime q has no", TARGET);
    println!("  sub-multiset of its mod-q factor degrees summing to {}.", TARGET);
    println!("  objects: F_X for X prime in [13, {}]  ({} polynomials, max degree {})",
             x_max, xs.len(), xs.last().unwrap() - 2);
    println!();

    let published: [(usize, u64); 19] = [
        (13, 5), (17, 2), (19, 2), (23, 3), (29, 3), (31, 2), (37, 11), (41, 2),
        (43, 2), (47, 2), (53, 3), (59, 2), (61, 2), (67, 2), (71, 2), (73, 2),
        (79, 2), (83, 2), (89, 2),
    ];

    let mut certified = 0usize;
    let mut failures: Vec<usize> = vec![];
    let mut replay_ok = 0usize;
    let mut replay_dis = 0usize;
    let mut worst_q = 2u64;
    let mut winners: Vec<(usize, u64)> = vec![];

    for &x in &xs {
        let f = f_x(x, &primes);
        let mut won: Option<u64> = None;
        for &q in &qs {
            if let Some(counts) = low_degree_counts(&f, q) {
                let mask = reachable(&counts);
                if mask & (1u32 << TARGET) == 0 {
                    won = Some(q);
                    break;
                }
            }
        }
        match won {
            Some(q) => {
                certified += 1;
                winners.push((x, q));
                if q > worst_q {
                    worst_q = q;
                }
                if let Some(&(_, pq)) = published.iter().find(|&&(px, _)| px == x) {
                    // The replay checks the CLAIM (no decic factor), not the
                    // choice of prime: a different search order may find a
                    // different valid certificate, and that is not a discrepancy.
                    if pq == q {
                        replay_ok += 1;
                    } else {
                        replay_dis += 1;
                        println!("    X={:<4} independent q={:<4} (published q={})", x, q, pq);
                    }
                }
            }
            None => {
                failures.push(x);
                println!("    X={:<4} NO CERTIFICATE with q <= 59", x);
            }
        }
    }

    println!();
    println!("  certified {} of {} objects", certified, xs.len());
    println!("  largest certifying prime needed: q = {}", worst_q);
    println!();
    println!("  which prime certified, by count (the search tries q ascending):");
    let mut hist: Vec<(u64, usize)> = vec![];
    for (_, q) in &winners {
        match hist.iter_mut().find(|h| h.0 == *q) {
            Some(h) => h.1 += 1,
            None => hist.push((*q, 1)),
        }
    }
    hist.sort();
    for (q, c) in &hist {
        println!(
            "    q = {:<4} certified {:>4} of {}  ({:.1}%)",
            q,
            c,
            xs.len(),
            100.0 * *c as f64 / xs.len() as f64
        );
    }
    println!();
    println!("  X needing q > 3 (the irregular objects):");
    let mut irregular: Vec<(usize, u64)> = winners.iter().cloned().filter(|(_, q)| *q > 3).collect();
    irregular.sort();
    if irregular.is_empty() {
        println!("    none");
    } else {
        for chunk in irregular.chunks(6) {
            let s: Vec<String> = chunk.iter().map(|(x, q)| format!("X={} (q={})", x, q)).collect();
            println!("    {}", s.join("   "));
        }
    }
    if !failures.is_empty() {
        println!("  objects with no certificate under q <= 59: {:?}", failures);
        println!("  ^ these are the live frontier: either a larger q certifies them,");
        println!("    or F_X genuinely admits a decic factor and the layer is inhabited.");
    }
    println!();
    println!("  REPLAY of the nineteen published certificates (13 <= X <= 89):");
    println!("    same conclusion AND same prime : {}", replay_ok);
    println!("    same conclusion, different prime: {}", replay_dis);
    println!("    conclusion contradicted         : {}",
             published.iter().filter(|&&(px, _)| failures.contains(&px)).count());
}
