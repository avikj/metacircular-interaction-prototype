#!/usr/bin/env python3
"""
exp60_ff_pairfield.py -- The function-field pair field: genus 0 (F_q[t]) and
genus 1 (elliptic-curve coordinate rings), exact identities.

Companion note: notes/FF_PAIRFIELD.md.  Builds on notes/FF.md (genus-0 shell
theory) and ATIYAH.md section 3 (the third dictionary column).

FORECAST (registered pre-run, 2026-08-12, per PROTOCOL section 4):
 (1) genus 0: sieved pi_q(d) == Gauss formula exactly at every degree;
     Lambda shell mass q^n exact; R^Lambda_n == (n-1) q^n exactly (q=2,3,5).
 (2) genus 1: direct affine point counts over F_{q^m} == q^m - s_m (Lucas
     recursion from a = q+1-#E(F_q)) exactly at every tested m; the
     main/single/pair layer decomposition has INTEGER residual exactly 0 at
     every n <= 40 for all three curves.
 (3) supersingular (a=0): pair layer == 0 on odd shells and
     == 2(n-2)(-q)^{n/2} on even shells, exactly.
 (4) Krein/Toeplitz (M=40): genuine curves PSD to machine precision
     (min eig >= -1e-9); Hasse-violating fake (a,q)=(5,5) min eig < -10.
 (5) wrong-Frobenius control: nonzero residual of order q^{n-1/2}.
Outcome space: any nonzero exact residual kills the layer algebra; any
point-count mismatch kills the Weil input or the enumeration.

Designed annihilation (prasanga norm, msg 0073):
  - control A: wrong-curve model (E1 data vs E2 Frobenius) must FAIL;
  - control B: Hasse-violating fake Frobenius (a=5, q=5) must break Krein
    positivity (and is checked against the integrality sieve, honestly);
  - control C: all identities are exact integer statements -- residual 0 or dead.

Everything arithmetic here is exact (Python big ints); floats appear only in
the Krein eigenvalue test and the figure.
"""

import itertools, math, sys, time
from math import comb, isqrt

t0 = time.time()

# ----------------------------------------------------------------------
# polynomial arithmetic over F_p (little-endian coefficient lists)
# ----------------------------------------------------------------------

def ptrim(f):
    while f and f[-1] == 0:
        f.pop()
    return f

def pmul(f, g, p):
    if not f or not g:
        return []
    out = [0] * (len(f) + len(g) - 1)
    for i, a in enumerate(f):
        if a:
            for j, b in enumerate(g):
                out[i + j] = (out[i + j] + a * b) % p
    return ptrim(out)

def pmod(f, g, p):
    # remainder of f by monic g
    f = f[:]
    dg = len(g) - 1
    inv = pow(g[-1], p - 2, p) if g[-1] != 1 else 1
    while len(f) - 1 >= dg and f:
        c = (f[-1] * inv) % p
        shift = len(f) - 1 - dg
        for i, b in enumerate(g):
            f[shift + i] = (f[shift + i] - c * b) % p
        ptrim(f)
    return f

def pgcd(f, g, p):
    f, g = f[:], g[:]
    while g:
        f, g = g, pmod(f, g, p)
    if f:
        inv = pow(f[-1], p - 2, p)
        f = [(c * inv) % p for c in f]
    return f

def ppow_p(f, mod, p):
    # f^p mod (monic mod), square-and-multiply on exponent p (p small)
    result = [1]
    base = f[:]
    e = p
    while e:
        if e & 1:
            result = pmod(pmul(result, base, p), mod, p)
        base = pmod(pmul(base, base, p), mod, p)
        e >>= 1
    return result

def is_irreducible(f, p):
    """Rabin test: f monic, deg d >= 1 over F_p."""
    d = len(f) - 1
    if d == 1:
        return True
    x = [0, 1]
    # Frobenius iterates F_i = x^{p^i} mod f
    frob = [x]
    t = x
    for _ in range(d):
        t = ppow_p(t, f, p)
        frob.append(t)
    if frob[d] != x:
        return False
    dd = d
    primes = set()
    m = d
    q_ = 2
    while q_ * q_ <= m:
        while m % q_ == 0:
            primes.add(q_)
            m //= q_
        q_ += 1
    if m > 1:
        primes.add(m)
    for ell in primes:
        t = frob[d // ell]
        diff = [(a - b) % p for a, b in
                itertools.zip_longest(t, x, fillvalue=0)]
        ptrim(diff)
        if len(pgcd(diff, f, p)) - 1 != 0:
            return False
    return True

def mobius(n):
    if n == 1:
        return 1
    m, res, k = n, 1, 0
    d = 2
    while d * d <= m:
        if m % d == 0:
            m //= d
            if m % d == 0:
                return 0
            k += 1
        d += 1
    if m > 1:
        k += 1
    return (-1) ** k

def divisors(n):
    return [d for d in range(1, n + 1) if n % d == 0]

def gauss_pi(q, d):
    """number of monic irreducibles of degree d over F_q (Gauss)"""
    s = sum(mobius(e) * q ** (d // e) for e in divisors(d))
    assert s % d == 0
    return s // d

# ----------------------------------------------------------------------
# PART 1: genus 0
# ----------------------------------------------------------------------

print("=" * 72)
print("PART 1: genus 0 -- F_q[t] (empty spectrum)")
print("=" * 72)

NMAX = 40
sieve_depth = {2: 12, 3: 8, 5: 6}

for q in (2, 3, 5):
    D = sieve_depth[q]
    pi_sieve = {}
    for d in range(1, D + 1):
        cnt = 0
        for tail in itertools.product(range(q), repeat=d):
            f = list(tail) + [1]
            if is_irreducible(f, q):
                cnt += 1
        pi_sieve[d] = cnt
    ok_pi = all(pi_sieve[d] == gauss_pi(q, d) for d in range(1, D + 1))
    print(f"[q={q}] sieve pi_q(d), d<=%d: %s ; matches Gauss formula EXACTLY: %s"
          % (D, [pi_sieve[d] for d in range(1, D + 1)], ok_pi))
    assert ok_pi

    # Lambda shell mass psi(m) = sum_{d|m} d pi(d) == q^m  (sieved range + formula range)
    ok_shell_sieved = all(
        sum(d * pi_sieve[d] for d in divisors(m)) == q ** m
        for m in range(1, D + 1))
    ok_shell_formula = all(
        sum(d * gauss_pi(q, d) for d in divisors(m)) == q ** m
        for m in range(1, NMAX + 1))
    print(f"[q={q}] Lambda shell mass psi(m)=q^m: sieved m<={D}: {ok_shell_sieved}; "
          f"formula m<={NMAX}: {ok_shell_formula}")
    assert ok_shell_sieved and ok_shell_formula

    # FF Theorem D, genus 0, Lambda weight: R^Lambda_n = (n-1) q^n EXACTLY
    psi = {m: q ** m for m in range(1, NMAX + 1)}
    ok_RL = all(
        sum(psi[a] * psi[n - a] for a in range(1, n)) == (n - 1) * q ** n
        for n in range(2, NMAX + 1))
    print(f"[q={q}] R^Lambda_n == (n-1) q^n exactly, 2<=n<={NMAX}: {ok_RL}"
          f"   (max residual = 0)")
    assert ok_RL

    # Cesaro-1 in degree: G1_n = sum_{a+b<=n} (n-a-b) psi psi ; exact closed form
    def G1(n):
        return sum((n - a - b) * psi[a] * psi[b]
                   for a in range(1, n) for b in range(1, n - a))
    def G1_closed(n):
        return sum((n - m) * (m - 1) * q ** m for m in range(2, n + 1))
    ok_G1 = all(G1(n) == G1_closed(n) for n in range(3, 26))
    print(f"[q={q}] Cesaro-1 G1_n == sum (n-m)(m-1)q^m exactly, n<=25: {ok_G1}")
    assert ok_G1

    # irreducible-pair counts and the harmonic main term (combinatorial, no oscillation)
    piq = {d: gauss_pi(q, d) for d in range(1, NMAX + 1)}
    print(f"[q={q}] R_n (irreducible pairs) vs harmonic main term "
          f"(2 H_(n-1)/n) q^n; correction/q^(n-1):")
    for n in (10, 20, 30, 40):
        Rn = sum(piq[a] * piq[n - a] for a in range(1, n))
        H = sum(1.0 / a for a in range(1, n))
        lead = 2 * H / n * q ** n
        corr = (Rn - lead) / q ** (n - 1)
        print(f"        n={n:2d}: R_n={Rn}  R_n/lead={Rn/lead:.6f}  "
              f"(R_n-lead)/q^(n-1)={corr:+.4f}")

# degree-shell homometry degeneracy: impostor counts
print()
print("Degree-shell homometry failure (impostor sets sharing ALL degree-pair data):")
for q, D0 in ((2, 4), (3, 3)):
    prod = 1
    for d in range(1, D0 + 1):
        prod *= comb(q ** d, gauss_pi(q, d))
    print(f"  q={q}, degrees<= {D0}: number of monic-set impostors = {prod}"
          f"  (= prod_d C(q^d, pi_q(d)))")

# ----------------------------------------------------------------------
# PART 2: genus 1 -- elliptic coordinate rings
# ----------------------------------------------------------------------

print()
print("=" * 72)
print("PART 2: genus 1 -- affine coordinate rings A = F_q[x,y]/(y^2-x^3-Ax-B)")
print("=" * 72)

def find_irreducible(p, m):
    for tail in itertools.product(range(p), repeat=m):
        g = list(tail) + [1]
        if is_irreducible(g, p):
            return g
    raise RuntimeError

def affine_count_direct(p, A, B, m):
    """#{(x,y) in F_{p^m}^2 : y^2 = x^3 + A x + B} by direct enumeration."""
    if m == 1:
        cnt = 0
        sq = {(z * z) % p for z in range(1, p)}
        for x in range(p):
            rhs = (x * x * x + A * x + B) % p
            if rhs == 0:
                cnt += 1
            elif rhs in sq:
                cnt += 2
        return cnt
    g = find_irreducible(p, m)
    elems = [list(t) for t in itertools.product(range(p), repeat=m)]
    sq = set()
    for z in elems:
        zz = pmod(pmul(z, z, p), g, p)
        sq.add(tuple(zz + [0] * (m - len(zz))))
    zero = tuple([0] * m)
    sq.discard(zero)
    cnt = 0
    Apoly = [A % p] if A % p else []
    Bpoly = [B % p] if B % p else []
    for x in elems:
        x2 = pmod(pmul(x, x, p), g, p)
        x3 = pmod(pmul(x2, x, p), g, p)
        ax = pmul(Apoly, x, p)
        rhs = [0] * m
        for i, c in enumerate(x3):
            rhs[i] = (rhs[i] + c) % p
        for i, c in enumerate(ax):
            rhs[i] = (rhs[i] + c) % p
        for i, c in enumerate(Bpoly):
            rhs[i] = (rhs[i] + c) % p
        rhs_t = tuple(rhs)
        if rhs_t == zero:
            cnt += 1
        elif rhs_t in sq:
            cnt += 2
    return cnt

class Zalpha:
    """exact arithmetic in Z[alpha], alpha^2 = a*alpha - q"""
    __slots__ = ("u", "v", "a", "q")
    def __init__(self, u, v, a, q):
        self.u, self.v, self.a, self.q = u, v, a, q
    def __mul__(self, o):
        # (u1 + v1 al)(u2 + v2 al) = u1u2 + (u1v2+v1u2) al + v1v2 (a al - q)
        u = self.u * o.u - self.v * o.v * self.q
        v = self.u * o.v + self.v * o.u + self.v * o.v * self.a
        return Zalpha(u, v, self.a, self.q)
    def __sub__(self, o):
        return Zalpha(self.u - o.u, self.v - o.v, self.a, self.q)
    def trace(self):
        return 2 * self.u + self.a * self.v

curves = [
    ("E1: y^2=x^3+x+1 / F_5", 5, 1, 1),
    ("E2: y^2=x^3+1   / F_5", 5, 0, 1),
    ("E3: y^2=x^3+x+3 / F_7", 7, 1, 3),
]

direct_depth = {5: 6, 7: 5}
results = {}

for name, p, A, B in curves:
    q = p
    disc = (4 * A ** 3 + 27 * B ** 2) % p
    assert disc != 0, "singular curve"
    N1_aff = affine_count_direct(p, A, B, 1)
    NE = N1_aff + 1                      # one rational point at infinity
    a = q + 1 - NE
    assert a * a <= 4 * q, "Hasse violated?!"
    print(f"\n{name}: #E(F_{q}) = {NE}, trace a = {a}"
          f"{'  (SUPERSINGULAR, alpha = +-i sqrt(q))' if a == 0 else ''}")

    # Lucas sequences: s_m = alpha^m + bar^m ; U_m = h_m(alpha,bar)
    s = {0: 2, 1: a}
    U = {0: 1, 1: a}
    for m in range(2, NMAX + 2):
        s[m] = a * s[m - 1] - q * s[m - 2]
        U[m] = a * U[m - 1] - q * U[m - 2]

    # (i) Weil input check: direct affine counts == q^m - s_m
    M = direct_depth[p]
    all_ok = True
    counts = []
    for m in range(1, M + 1):
        direct = affine_count_direct(p, A, B, m)
        pred = q ** m - s[m]
        counts.append(direct)
        all_ok &= (direct == pred)
    print(f"  direct affine counts m<={M}: {counts}")
    print(f"  == q^m - s_m from a alone (Weil/Lefschetz), EXACT: {all_ok}")
    assert all_ok

    # (ii) closed points b_d: integrality + positivity (Mobius inversion)
    Psi = {m: q ** m - s[m] for m in range(1, NMAX + 1)}
    b = {}
    ok_b = True
    for d in range(1, NMAX + 1):
        tot = sum(mobius(e) * Psi[d // e] for e in divisors(d))
        ok_b &= (tot % d == 0) and (tot >= 0)
        b[d] = tot // d
    print(f"  closed-point counts b_d integral & nonneg (d<=40): {ok_b}; "
          f"b_1..b_6 = {[b[d] for d in range(1, 7)]}")
    assert ok_b

    # (iii) FF Theorem D at genus 1: exact three-layer decomposition
    #   R_n = sum_{a+b=n} Psi(a)Psi(b)
    #       = (n-1) q^n  - 2 T_n  + [(n-1) s_n + 2 q U_{n-2}]
    #   with T_n = sum_{a=1}^{n-1} q^a s_{n-a}
    max_resid = 0
    layer_rows = []
    for n in range(2, NMAX + 1):
        R = sum(Psi[i] * Psi[n - i] for i in range(1, n))
        MAIN = (n - 1) * q ** n
        T = sum(q ** i * s[n - i] for i in range(1, n))
        SINGLE = -2 * T
        PAIR = (n - 1) * s[n] + 2 * q * U[n - 2]
        resid = R - (MAIN + SINGLE + PAIR)
        max_resid = max(max_resid, abs(resid))
        layer_rows.append((n, MAIN, SINGLE, PAIR))
        # closed form for T_n via exact Z[alpha] arithmetic:
        #   sum q^a alpha^{n-a} = q*alpha*(q^{n-1}-alpha^{n-1})/(q-alpha)
        al = Zalpha(0, 1, a, q)
        aln1 = Zalpha(1, 0, a, q)
        for _ in range(n - 1):
            aln1 = aln1 * al
        w = Zalpha(q, 0, a, q) * al * (Zalpha(q ** (n - 1), 0, a, q) - aln1)
        # divide by (q - alpha): multiply by conjugate (q - a + alpha), divide by norm
        conj = Zalpha(q - a, 1, a, q)
        nu = q * q - a * q + q          # (q-alpha)(q-bar) = q(q+1-a) = q * #E(F_q)
        wc = w * conj
        assert wc.u % nu == 0 and wc.v % nu == 0, "divided difference not exact!"
        T_closed = Zalpha(wc.u // nu, wc.v // nu, a, q).trace()
        assert T_closed == T, "Z[alpha] closed form for T_n failed"
    print(f"  layer identity R_n = (n-1)q^n - 2 T_n + [(n-1)s_n + 2q U_(n-2)]:"
          f"  max |integer residual| over 2<=n<=40 = {max_resid}")
    assert max_resid == 0
    print(f"  T_n closed form q*al*(q^(n-1)-al^(n-1))/(q-al) + conj "
          f"verified EXACTLY in Z[alpha]; denominator norm = q*#E(F_q) = {q*(q+1-a)}")

    # (iii-b) exact resolution of the pole x zero layer:
    #   T_n = [ (a-2) q^n + q (s_{n-1} - s_n) ] / N1,   N1 = #E(F_q) = q+1-a
    # i.e. a SMOOTH secondary term (freq 0) + the true single-zero oscillation
    # with weight 2q/N1 -- the FF avatar of BLOCKS.md section 0's mixed block
    # (smooth secondary terms + single-gamma lines, coefficient exactly 2).
    N1 = q + 1 - a
    ok_T = True
    for n in range(2, NMAX + 1):
        T = sum(q ** i * s[n - i] for i in range(1, n))
        num = (a - 2) * q ** n + q * (s[n - 1] - s[n])
        ok_T &= (num % N1 == 0) and (num // N1 == T)
    print(f"  resolved mixed layer T_n = [(a-2)q^n + q(s_(n-1)-s_n)]/N1 exact "
          f"(N1=#E(F_q)={N1}): {ok_T}")
    assert ok_T
    if a == 2:
        print("  NOTE: a=2 kills the smooth part of the mixed layer exactly "
              "((a-2)/N1 = 0): pure single-zero oscillation")

    # layer magnitudes at n=20 (for the note), with the mixed layer resolved
    n = 20
    MAIN = (n - 1) * q ** n
    SM_MIXED = -2 * (a - 2) * q ** n // N1 if (2 * (a - 2) * q ** n) % N1 == 0 \
        else -2 * (a - 2) * q ** n / N1
    OSC_SINGLE = 2 * q * (s[n] - s[n - 1]) / N1
    PAIR = (n - 1) * s[n] + 2 * q * U[n - 2]
    print(f"  n=20 resolved layers: MAIN={MAIN}  smooth-mixed~{SM_MIXED}  "
          f"osc-single~{OSC_SINGLE:.4g}  PAIR={PAIR}")
    print(f"    ratios to MAIN: smooth {abs(SM_MIXED)/MAIN:.3e}, "
          f"single-osc {abs(OSC_SINGLE)/MAIN:.3e}, pair {abs(PAIR)/MAIN:.3e}")

    # supersingular rigidity
    if a == 0:
        ok_odd = all(((n - 1) * s[n] + 2 * q * U[n - 2]) == 0
                     for n in range(3, NMAX + 1, 2))
        ok_even = all(((n - 1) * s[n] + 2 * q * U[n - 2])
                      == 2 * (n - 2) * (-q) ** (n // 2)
                      for n in range(2, NMAX + 1, 2))
        print(f"  SUPERSINGULAR rigidity: pair layer == 0 on odd shells: {ok_odd}; "
              f"== 2(n-2)(-q)^(n/2) on even shells: {ok_even}")
        assert ok_odd and ok_even

    # unweighted irreducible-pair counts (flavor)
    Bn = {n: sum(b[i] * b[n - i] for i in range(1, n)) for n in range(2, 13)}
    print(f"  unweighted closed-point pair counts B_n, n=2..12: "
          f"{[Bn[n] for n in range(2, 13)]}")

    results[name] = dict(q=q, a=a, s=s, U=U, Psi=Psi, b=b)

# ----------------------------------------------------------------------
# control A: wrong-curve model (E1 data against E2 Frobenius)
# ----------------------------------------------------------------------
print()
print("CONTROL A (designed annihilation): E1 pair data vs E2 (a=0) zero model")
r1 = results["E1: y^2=x^3+x+1 / F_5"]
r2 = results["E2: y^2=x^3+1   / F_5"]
q = 5
for n in (10, 20, 30):
    R = sum(r1["Psi"][i] * r1["Psi"][n - i] for i in range(1, n))
    MAIN = (n - 1) * q ** n
    Tw = sum(q ** i * r2["s"][n - i] for i in range(1, n))
    PAIRw = (n - 1) * r2["s"][n] + 2 * q * r2["U"][n - 2]
    residw = R - (MAIN - 2 * Tw + PAIRw)
    print(f"  n={n:2d}: wrong-model residual = {residw}  "
          f"residual/q^(n-1/2) = {residw / q**(n-0.5):+.4f}   (must be nonzero)")
    assert residw != 0

# ----------------------------------------------------------------------
# control B + Krein/screw positivity
# ----------------------------------------------------------------------
print()
print("KREIN / SCREW TEST: c_m = s_m / q^(m/2) positive-definite <=> |alpha|=sqrt(q) (=Weil RH)")
import numpy as np

def toeplitz_mineig(a, q, M=40):
    rq = math.sqrt(q)
    c = [2.0, a / rq]
    for m in range(2, M):
        c.append((a / rq) * c[m - 1] - c[m - 2])
    T = np.array([[c[abs(i - j)] for j in range(M)] for i in range(M)])
    return float(np.linalg.eigvalsh(T).min()), c

eigs_fig = {}
for name, p, A, B in curves:
    a = results[name]["a"]
    mn, _ = toeplitz_mineig(a, p)
    eigs_fig[name] = (a, p)
    print(f"  {name}: a={a:+d}, Toeplitz(40) min eig = {mn:+.3e}  (PSD to machine precision)")
    assert mn > -1e-9

# fake Frobenius violating Hasse: a=5, q=5 (a^2=25 > 4q=20). No such curve exists
# (Honda-Tate/Hasse); the point: which layer of structure detects it?
a_f, q_f = 5, 5
mn_f, _ = toeplitz_mineig(a_f, q_f)
print(f"  CONTROL B: fake (a,q)=({a_f},{q_f}) [violates |a|<=2 sqrt(q)]:"
      f" Toeplitz(40) min eig = {mn_f:+.3e}  (MUST be very negative)")
assert mn_f < -10
# honesty check: does the integrality/positivity sieve already catch the fake?
s_f = {0: 2, 1: a_f}
for m in range(2, 41):
    s_f[m] = a_f * s_f[m - 1] - q_f * s_f[m - 2]
bad = None
for d in range(1, 41):
    tot = sum(mobius(e) * (q_f ** (d // e) - s_f[d // e]) for e in divisors(d))
    if tot % d != 0 or tot < 0:
        bad = (d, tot)
        break
print(f"  fake integrality sieve: first failure at d={bad[0]} "
      f"(sum={bad[1]})" if bad else
      "  fake passes the integrality sieve at all d<=40 -- Krein is the discriminator")

# ----------------------------------------------------------------------
# figure
# ----------------------------------------------------------------------
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

C_BLUE, C_ORANGE, C_AQUA, C_RED = "#2a78d6", "#eb6834", "#1baf7a", "#e34948"
TEXT1, TEXT2, GRID = "#0b0b0b", "#52514e", "#e6e5e1"

fig, axes = plt.subplots(1, 2, figsize=(11.5, 4.4), facecolor="#fcfcfb")

# panel 1: layer hierarchy for E1 (mixed layer resolved into smooth + oscillatory)
ax = axes[0]
r1 = results["E1: y^2=x^3+x+1 / F_5"]
q = 5
a1 = r1["a"]; N1 = q + 1 - a1
ns = list(range(2, 41))
main_l, smooth_l, single_l, pair_l = [], [], [], []
for n in ns:
    MAIN = (n - 1) * q ** n
    PAIR = (n - 1) * r1["s"][n] + 2 * q * r1["U"][n - 2]
    main_l.append(MAIN)
    smooth_l.append(abs(2 * (a1 - 2) * q ** n / N1))
    single_l.append(abs(2 * q * (r1["s"][n] - r1["s"][n - 1]) / N1))
    pair_l.append(abs(PAIR))
ax.semilogy(ns, main_l, color=C_BLUE, lw=2, label="main  $(n{-}1)q^n$")
ax.semilogy(ns, smooth_l, color="#eda100", lw=2, ls=":",
            label=r"mixed, smooth  $2|a{-}2|q^n/N_1$")
ax.semilogy(ns, single_l, color=C_ORANGE, lw=2,
            label=r"mixed, single-zero osc.  $|2q(s_n{-}s_{n-1})/N_1|$")
ax.semilogy(ns, pair_l, color=C_AQUA, lw=2, label=r"pair  $|(n{-}1)s_n+2qU_{n-2}|$")
ax.set_title("E1/$\\mathbf{F}_5$: exact layers of $R_n^\\Lambda$ (integer residual $=0$ at every $n$)",
             fontsize=10, color=TEXT1)
ax.set_xlabel("degree shell $n$", color=TEXT2)
ax.set_ylabel("layer magnitude", color=TEXT2)
ax.legend(frameon=False, fontsize=9)

# panel 2: Krein spectrum, genuine vs fake
ax = axes[1]
mn1, c1 = toeplitz_mineig(results["E1: y^2=x^3+x+1 / F_5"]["a"], 5)
T1 = np.array([[c1[abs(i - j)] for j in range(40)] for i in range(40)])
e1 = np.sort(np.linalg.eigvalsh(T1))
mnf, cf = toeplitz_mineig(5, 5)
Tf = np.array([[cf[abs(i - j)] for j in range(40)] for i in range(40)])
ef = np.sort(np.linalg.eigvalsh(Tf))
idx = np.arange(1, 41)
ax.plot(idx, np.maximum(e1, 1e-18), color=C_BLUE, lw=2,
        label="E1 (Weil RH true): all $\\lambda_k \\geq 0$")
ax.plot(idx, np.abs(ef), color=C_RED, lw=2, ls="--",
        label="fake $a=5,q=5$: $|\\lambda_k|$ (min $=-2.3\\times10^{8}$)")
ax.set_yscale("log")
ax.set_title("Krein/screw form: Toeplitz$[s_{|i-j|}/q^{|i-j|/2}]$ spectrum",
             fontsize=10, color=TEXT1)
ax.set_xlabel("eigenvalue index (sorted)", color=TEXT2)
ax.set_ylabel("$|\\lambda_k|$", color=TEXT2)
ax.legend(frameon=False, fontsize=9)

for ax in axes:
    ax.grid(True, color=GRID, lw=0.7)
    ax.set_facecolor("#fcfcfb")
    for sp in ax.spines.values():
        sp.set_color(GRID)
    ax.tick_params(colors=TEXT2)

fig.tight_layout()
fig.savefig("../figures/exp60_ff_pairfield.png", dpi=160)
print("\nfigure: figures/exp60_ff_pairfield.png")
print(f"total time: {time.time() - t0:.1f} s")
print("ALL ASSERTIONS PASSED (every arithmetic identity exact; residuals integer 0).")
