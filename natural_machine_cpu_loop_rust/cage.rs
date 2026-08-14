// The sharp root cage, cashed: how much does phi^{-1} < |z| < sqrt(2) shrink the
// certificate boxes that degrees 4-9 were actually closed with?
//
// CROSS_LENS.md section 6 item 5 has flagged this as an unclaimed join since
// 2026-08-12: NONRECIPROCAL_DECIC_FRONTIER section 1 proves the sharp cage for
// every F_X (odd support, odd top exponent, monic, constant term 1), while F4-F9
// all ran with the generic 0-1 bound 1/2 < |z| < 2. "Every certificate box is
// valid but substantially oversized; re-running with sqrt2 might make degree ten
// tractable." Nobody put a number on it. This does.
//
// Exact integer arithmetic only. The irrationals enter as RATIONAL OVER-ESTIMATES
// of the upper bounds and RATIONAL UNDER-ESTIMATES of the lower bound, so every
// coefficient bound printed is a valid majorant -- rounding can only loosen the
// box, never tighten it past the truth. No floating point is used for any
// decision.
//
// Objects (NONRECIPROCAL_DECIC_FRONTIER (0.1), generalized to degree 2m):
//   q(x) = x^{2m} + a_1 x^{2m-1} + ... + a_{2m-1} x + 1
// totally nonreal, so the roots are m conjugate pairs of radii r_1..r_m with
// prod r_k = 1 (unit constant term). Each Vieta modulus majorant |a_k| is the
// k-th elementary symmetric function of the 2m-item multiset (r_1,r_1,...,r_m,r_m),
// a symmetric convex function of the log radii, hence maximized at a vertex of
// the log-polytope {B <= r <= A, sum log r = 0}. At a vertex m-1 coordinates sit
// at bounds; with s of them at the upper bound the compensating radius is
//   c_s = A^{-s} B^{-(m-1-s)}    (so that the product is 1)
// and the vertex is feasible iff B <= c_s <= A. The majorant vector is then read
// off the coefficients of prod_k (1 + r_k z)^2.

// ---------------------------------------------------------------- exact rationals
//
// Fixed-denominator arithmetic on u128 with denominator 10^D. Numerators only;
// the denominator is tracked by hand in the polynomial degree.

const D: u32 = 3; // decimal digits of precision in the algebraic constants
const SCALE: u128 = 1000; // 10^D

// Rational OVER-estimates (safe as upper bounds on radii):
//   sqrt(2)   = 1.41421356... <= 1.415
//   phi       = 1.61803398... <= 1.619
//   phi^2/2   = 1.30901699... <= 1.310
// Rational UNDER-estimate (safe as a lower bound on radii):
//   phi^{-1}  = 0.61803398... >= 0.618
const SQRT2_UP: u128 = 1415;
const PHIINV_DOWN: u128 = 618;
const PHIINV_UP: u128 = 619; // for use where phi^{-1} appears as an upper bound
const TWO: u128 = 2000;
const HALF: u128 = 500;

/// Multiply the polynomial `p` (coefficients scaled by SCALE^p.len()-ish, tracked
/// by the caller) by (SCALE + r*z), where `r` is a scaled numerator.
fn mul_linear(p: &[u128], r: u128) -> Option<Vec<u128>> {
    let mut out = vec![0u128; p.len() + 1];
    for (i, &c) in p.iter().enumerate() {
        out[i] = out[i].checked_add(c.checked_mul(SCALE)?)?;
        out[i + 1] = out[i + 1].checked_add(c.checked_mul(r)?)?;
    }
    Some(out)
}

/// Coefficients of prod_k (1 + r_k z)^2 for the given scaled radii, returned as
/// exact integer ceilings of the true rational values. Each radius appears twice.
/// After multiplying `2m` linear factors the common denominator is SCALE^{2m}.
/// Coefficients are INTEGERS, so a real majorant M gives the integer bound
/// floor(M). The radii are over-estimated, so floor(over-estimate) >= floor(true):
/// the printed bound is always valid, and can only be loose, never tight-by-luck.
fn majorant(radii: &[u128]) -> Option<Vec<u128>> {
    let mut p: Vec<u128> = vec![1];
    let mut den_pow = 0u32;
    for &r in radii {
        for _ in 0..2 {
            p = mul_linear(&p, r)?;
            den_pow += 1;
        }
    }
    let den = SCALE.checked_pow(den_pow)?;
    Some(p.iter().map(|&c| c / den).collect())
}

/// Feasible vertex radii for m conjugate pairs under B <= r <= A, prod r = 1.
/// Returns the multiset of scaled radii, or None if no vertex is feasible.
fn vertex(m: usize, a_up: u128, b_low: u128, b_up: u128, a_low: u128) -> Option<Vec<u128>> {
    // Search s = number of upper-bound coordinates among the m-1 pinned ones.
    for s in 0..m {
        if s > m - 1 {
            break;
        }
        // c_s = 1 / (A^s * B^{m-1-s}); compute an OVER-estimate of c_s by using
        // under-estimates of A and B in the denominator.
        let lo = m - 1 - s;
        // denominator, scaled: A_low^s * B_low^lo / SCALE^{s+lo-1}
        let mut num = SCALE; // represents 1 in scaled units
        let mut den = 1u128;
        let mut den_scale = 0u32;
        for _ in 0..s {
            den *= a_low;
            den_scale += 1;
        }
        for _ in 0..lo {
            den *= b_low;
            den_scale += 1;
        }
        if den == 0 {
            continue;
        }
        // c_s (scaled) = SCALE^{den_scale+1} / den, rounded up
        num = SCALE.pow(den_scale + 1);
        let c_up = (num + den - 1) / den;
        let c_down = num / den;
        // feasibility: B <= c <= A, tested with safe rounding
        if c_down >= b_low && c_up <= a_up {
            let mut radii = vec![a_up; s];
            for _ in 0..lo {
                radii.push(b_up);
            }
            radii.push(c_up);
            return Some(radii);
        }
    }
    None
}

fn box_size(bounds: &[u128]) -> f64 {
    // reported only as an order of magnitude; the exact comparison is the ratio
    // of products of (2b+1), computed exactly below in log form to avoid overflow
    bounds.iter().map(|&b| ((2 * b + 1) as f64).ln()).sum::<f64>()
}

fn main() {
    println!("The sharp cage, cashed: certificate box sizes at even degree");
    println!("  sharp   cage  phi^-1 < |z| < sqrt2   (NONRECIPROCAL_DECIC_FRONTIER (1.1))");
    println!("  generic cage    1/2   < |z| <   2    (the 0-1 bound F4-F9 actually used)");
    println!();
    println!("  deg   sharp Vieta majorants                              generic majorants                              log10 box ratio");

    for m in 2..=6usize {
        let deg = 2 * m;
        let sharp = vertex(m, SQRT2_UP, PHIINV_DOWN, PHIINV_UP, 1414);
        let generic = vertex(m, TWO, HALF, HALF, 1999);
        match (sharp, generic) {
            (Some(rs), Some(rg)) => {
                let (bs, bg) = match (majorant(&rs), majorant(&rg)) {
                    (Some(x), Some(y)) => (x, y),
                    _ => {
                        println!(
                            "  {:>3}   u128 exhausted at {}-digit precision -- not reported rather than reported wrong",
                            deg, D
                        );
                        continue;
                    }
                };
                // drop the leading 1 and trailing 1 (monic, constant term)
                let inner_s: Vec<u128> = bs[1..bs.len() - 1].to_vec();
                let inner_g: Vec<u128> = bg[1..bg.len() - 1].to_vec();
                let ls = box_size(&inner_s);
                let lg = box_size(&inner_g);
                let ratio_log10 = (lg - ls) / std::f64::consts::LN_10;
                println!(
                    "  {:>3}   {:<46}  log10 vol {:>6.2}   generic log10 vol {:>6.2}   shrink 10^{:.2}",
                    deg,
                    format!("{:?}", inner_s),
                    ls / std::f64::consts::LN_10,
                    lg / std::f64::consts::LN_10,
                    ratio_log10
                );
            }
            _ => println!("  {:>3}   no feasible vertex", deg),
        }
    }

    println!();
    println!("The published degree-10 vector for comparison (note (2.3)):");
    println!("  [10, 51, 142, 257, 312, 258, 144, 51, 10]");
    println!();
    println!("Ratio column is log10 of (generic box volume / sharp box volume), where a");
    println!("box volume is the product of (2*bound + 1) over the free coefficients.");
    println!("It is the exact factor by which every closed certificate at that degree was");
    println!("enumerated larger than the sharp cage required.");
}
