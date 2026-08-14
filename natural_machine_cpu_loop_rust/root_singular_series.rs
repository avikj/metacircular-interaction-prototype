// Delta 17 section 17.23 item 3: local singular series factors directly from
// A_{k-1} collision/root data.
//
// THE STATEMENT UNDER TEST.
//
// For a k-tuple H = (h_1,...,h_k) of distinct integers, the Hardy-Littlewood
// local factor at p is
//
//     sigma_p(H) = (1 - nu_p(H)/p) * (1 - 1/p)^{-k},
//
// where nu_p(H) is the number of distinct residues of H mod p (this is the form
// the corpus already carries: notes/ADELIC.md section 1, "the k-tuple version
// with nu_p(H) forbidden classes is exact").
//
// Delta 17 section 17.16 supplies the root system: the additive relative
// coordinates of a k-tuple are the A_{k-1} roots h_i - h_j. So define the
// VANISHING SET
//
//     Phi_p(H) = { alpha in Phi(A_{k-1}) : alpha(H) = 0 mod p }
//              = { e_i - e_j : h_i = h_j mod p }.
//
// CLAIM:  nu_p(H) = k - rank Phi_p(H),
//
// where the rank is the dimension of the Q-span of the vanishing roots inside
// R^k. Hence the local factor depends on H only through the RANK of a root
// subsystem, and admissibility (nonvanishing of the singular series) becomes
//
//     for every prime p <= k:   rank Phi_p(H) > k - p.
//
// WHY THIS IS NOT CIRCULAR. The obvious "proof" is that both sides count blocks
// of the partition induced by H mod p, which is true and is exactly why the
// check must not compute the rank that way. This program computes:
//
//   * nu_p(H) by direct residue counting;
//   * rank Phi_p(H) by GAUSSIAN ELIMINATION over Q on the explicit list of
//     vanishing root vectors in Z^k, touching no partition and no block count.
//
// Two independent routes to the same integer. Exact integer/rational arithmetic
// throughout; no floating point.
//
//   rustc -O root_singular_series.rs -o root_singular_series && ./root_singular_series

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

/// nu_p(H): number of distinct residues of H mod p. Direct count.
fn nu(h: &[i64], p: i64) -> usize {
    let mut seen = vec![false; p as usize];
    let mut c = 0;
    for &x in h {
        let r = (((x % p) + p) % p) as usize;
        if !seen[r] {
            seen[r] = true;
            c += 1;
        }
    }
    c
}

/// The vanishing root vectors e_i - e_j in Z^k, for i<j with h_i = h_j mod p.
fn vanishing_roots(h: &[i64], p: i64) -> Vec<Vec<i64>> {
    let k = h.len();
    let mut out = vec![];
    for i in 0..k {
        for j in (i + 1)..k {
            if (h[i] - h[j]).rem_euclid(p) == 0 {
                let mut v = vec![0i64; k];
                v[i] = 1;
                v[j] = -1;
                out.push(v);
            }
        }
    }
    out
}

/// Rank over Q by fraction-free Gaussian elimination on integer rows.
/// No partition, no block count: pure linear algebra on the root vectors.
fn rank_q(rows_in: &[Vec<i64>]) -> usize {
    let mut rows: Vec<Vec<i128>> = rows_in
        .iter()
        .map(|r| r.iter().map(|&x| x as i128).collect())
        .collect();
    if rows.is_empty() {
        return 0;
    }
    let n = rows[0].len();
    let mut rank = 0usize;
    let mut row = 0usize;
    for col in 0..n {
        // find pivot
        let mut piv = None;
        for r in row..rows.len() {
            if rows[r][col] != 0 {
                piv = Some(r);
                break;
            }
        }
        let piv = match piv {
            Some(x) => x,
            None => continue,
        };
        rows.swap(row, piv);
        // eliminate below, fraction-free (Bareiss-style cross multiplication)
        for r in (row + 1)..rows.len() {
            if rows[r][col] != 0 {
                let a = rows[row][col];
                let b = rows[r][col];
                for c in 0..n {
                    rows[r][c] = a * rows[r][c] - b * rows[row][c];
                }
                // keep entries small
                let g = rows[r].iter().fold(0i128, |acc, &x| gcd(acc, x.abs()));
                if g > 1 {
                    for c in 0..n {
                        rows[r][c] /= g;
                    }
                }
            }
        }
        rank += 1;
        row += 1;
        if row == rows.len() {
            break;
        }
    }
    rank
}

fn gcd(a: i128, b: i128) -> i128 {
    if b == 0 { a } else { gcd(b, a % b) }
}

/// Exact rational local factor sigma_p(H) = (1 - nu/p)/(1-1/p)^k, as a fraction.
/// Numerator/denominator kept exact: (p - nu) * p^(k-1) / (p-1)^k.
fn local_factor(nu: usize, p: i64, k: usize) -> (i128, i128) {
    let num = (p as i128 - nu as i128) * (p as i128).pow((k - 1) as u32);
    let den = (p as i128 - 1).pow(k as u32);
    let g = gcd(num.abs(), den.abs()).max(1);
    (num / g, den / g)
}

fn main() {
    println!("Delta 17 item 3: the local singular series factor is a root-subsystem rank");
    println!();
    println!("  claim   nu_p(H) = k - rank Phi_p(H),  Phi_p(H) = roots vanishing mod p");
    println!("  routes  nu_p by residue counting; rank by Gaussian elimination over Q");
    println!("          on the explicit root vectors -- no partition touched");
    println!();

    let primes = primes_upto(60);
    let mut checks = 0u64;
    let mut disagreements = 0u64;

    // Exhaustive over all strictly increasing k-tuples in a window, all p.
    for k in 2..=5usize {
        let window: i64 = if k <= 3 { 22 } else { 14 };
        let mut idx = vec![0i64; k];
        for i in 0..k {
            idx[i] = i as i64;
        }
        loop {
            for &pu in &primes {
                let p = pu as i64;
                let n = nu(&idx, p);
                let r = rank_q(&vanishing_roots(&idx, p));
                checks += 1;
                if n != k - r {
                    disagreements += 1;
                    if disagreements <= 5 {
                        println!("    DISAGREE k={} p={} H={:?}: nu={} k-rank={}", k, p, idx, n, k - r);
                    }
                }
            }
            // next combination
            let mut i = k;
            loop {
                if i == 0 {
                    break;
                }
                i -= 1;
                if idx[i] < window - (k as i64 - 1 - i as i64) {
                    idx[i] += 1;
                    for j in (i + 1)..k {
                        idx[j] = idx[j - 1] + 1;
                    }
                    break;
                }
                if i == 0 {
                    break;
                }
            }
            if idx[0] > window - k as i64 {
                break;
            }
        }
    }
    println!("  exhaustive check: {} (k,H,p) instances, {} disagreements", checks, disagreements);

    println!();
    println!("  worked instances (the corpus's own tuples):");
    for (name, h) in [
        ("twin        {0,2}", vec![0i64, 2]),
        ("admissible  {0,2,6}", vec![0i64, 2, 6]),
        ("INADMISSIBLE{0,2,4}", vec![0i64, 2, 4]),
        ("quadruple   {0,2,6,8}", vec![0i64, 2, 6, 8]),
    ] {
        let k = h.len();
        println!("    {}  k={}", name, k);
        let mut admissible = true;
        for &pu in &primes {
            let p = pu as i64;
            if p > 13 {
                break;
            }
            let n = nu(&h, p);
            let r = rank_q(&vanishing_roots(&h, p));
            let (a, b) = local_factor(n, p, k);
            if n == p as usize {
                admissible = false;
            }
            println!(
                "      p={:<3} nu={} rank Phi_p={} k-rank={}  sigma_p = {}/{}{}",
                p,
                n,
                r,
                k - r,
                a,
                b,
                if n == p as usize { "   <-- VANISHES" } else { "" }
            );
        }
        println!(
            "      admissible: {}   (criterion: rank Phi_p > k - p for every p <= k)",
            admissible
        );
        for &pu in &primes {
            let p = pu as i64;
            if p as usize > k {
                break;
            }
            let r = rank_q(&vanishing_roots(&h, p));
            println!(
                "        p={}: rank Phi_p = {} vs k-p = {}  -> {}",
                p,
                r,
                k as i64 - p,
                if (r as i64) > k as i64 - p { "ok" } else { "FAILS" }
            );
        }
        println!();
    }
}
