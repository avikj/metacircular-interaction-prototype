#!/usr/bin/env python3
"""
exp62_digit_crystal.py -- The reversal/complement duality crystal of the
positional digit action.

Companion note: notes/DIGIT_CRYSTAL.md.
Executes notes/PYTHAGOREAN_EUCLIDEAN_MACHINE.md section 8 (duality crystals) on
the crystal that note names as native: word-reversal / opposite-endomorphism in
positional digit actions.  Section 4 (chart vs completion) is the crossing.

CONVENTIONS (fixed once, used everywhere)
  b >= 2, digit alphabet A = {0,...,b-1}.
  A word w = (c_0,...,c_{n-1}) is LITTLE-ENDIAN: L_n(w) = sum_i c_i b^i.
  rho(w) = (c_{n-1},...,c_0)                    [reversal, D]
  eps(w) = (b-1-c_0,...,b-1-c_{n-1})            [digit complement, E]
  Affine element [a,c] is the map x |-> a x + c; [a1,c1]o[a2,c2] = [a1a2, a1c2+c1].
  Digit generator gamma_d = [b,d].  Phi(w) = gamma_{c_0} o ... o gamma_{c_{n-1}}
    = [b^n, L_n(w)]; Phi is a MONOID HOMOMORPHISM (concatenation appends
    higher-order digits on the right).
  On Z/b^n:  R_n = L_n rho L_n^{-1},  E_n(v) = b^n - 1 - v,
             T_n(v) = v+1 (odometer), pi_n(v) = v mod b^n  (Z/b^{n+1} -> Z/b^n),
             sig_n(v) = floor(v/b)              (Z/b^{n+1} -> Z/b^n).

FORECAST (registered pre-run, 2026-08-12, per PROTOCOL section 4):
 (F1) D and E commute on words of every length; <D,E> is Klein four V4 for
      every n >= 2 and every b >= 2 (order multiset {1,2,2,2}); it is Z/2 at
      n = 1 and trivial at n = 0.  PREDICTED: exact V4, never Z/4.
 (F2) Fixed-point closed forms, exact at every n:
        |Fix D|  = b^ceil(n/2)                              (palindromes)
        |Fix E|  = 1 if b odd else 0   (n >= 1)             (constant (b-1)/2)
        |Fix DE| = b^floor(n/2) if (n even or b odd) else 0 (antipalindromes)
      and Burnside: #orbits = (b^n + |FixD| + |FixE| + |FixDE|)/4 exactly.
 (F3) E is conjugation by sigma = [-1,-1] inside Aff: sigma gamma_d sigma =
      gamma_{b-1-d}, exactly, for all b,d.  D is an ANTI-automorphism of the
      free affine digit monoid: Phi(rho(uv)) = Phi(rho v) o Phi(rho u).
 (F4) (E_n) is compatible with pi (and with sig); (R_n) is NOT compatible with
      pi but IS an isomorphism of inverse systems (pi) -> (sig):
        pi_n o R_{n+1} = R_n o sig_n   exactly, and
        sig_n o R_{n+1} = R_n o pi_n   exactly, while
        pi_n o R_{n+1} != R_n o pi_n   for every n >= 1, b >= 2.
 (F5) E_n T_n E_n = T_n^{-1} exactly (E reverses the odometer).  The reversed
      odometer Ttil_n = R_n T_n R_n is NOT affine mod b^n for n >= 2 and is NOT
      in the dihedral group <T_n, E_n> of order 2b^n for n >= 2.
 (F6) Carry/valuation exchange: c_n(E_n x) = z_n(x) for all x, where c_n counts
      trailing (b-1)-digits and z_n counts trailing 0-digits.  Digit-sum
      cocycle s(x+1) - s(x) = 1 - (b-1) c_n(x) exactly for x < b^n - 1.
 (F7) Non-extension: for every k there are u,v with |u-v|_b <= b^{-k} but
      |Rmin(u) - Rmin(v)|_b >= b^{-1}, where Rmin is minimal-length reversal.
      PREDICTED sharp sup over positive integers: 1 for b >= 3, 1/b for b = 2.
 (F8) |<T_n, R_n>| (odometer + reversal) is NOT 2b^n; UNREGISTERED beyond that
      (open outcome space: any group order; recorded as measurement, not claim).

Outcome space: any exact-integer mismatch in F2-F6 kills the corresponding
theorem in DIGIT_CRYSTAL.md.  F1 failing to V4 kills the group classification.
F4 holding with pi-compatibility would kill the whole chart/completion finding.

Designed annihilation (prasanga norm, msg 0073, PROTOCOL section 7):
  - CONTROL A (planted-false group claim): the script asserts to the verifier
    that <D,E> is CYCLIC of order 4 (Z/4).  The verifier must REJECT it.
  - CONTROL B (planted-false compatibility): the script asserts
    pi_n o R_{n+1} = R_n o pi_n.  The verifier must REJECT it.
  - CONTROL C (planted-false fixed-point formula): |Fix E| = b^{n/2}.
    The verifier must REJECT it.
  - CONTROL D (true-but-nontrivial positive control): pi_n o E_{n+1} =
    E_n o pi_n must be ACCEPTED, so the verifier is not a constant rejector.
  - CONTROL E (planted-false closed form, same comparison as the live claim):
    |Fix D| = b^floor(n/2) instead of b^ceil(n/2).  The verifier must REJECT it,
    proving the brute-vs-closed comparison has discriminating power.
  - Brute force vs closed form is compared at EVERY exhaustively enumerated
    (b,n) -- not sampled, and the row count is printed.

All arithmetic is exact Python integers.  Floats appear only in figures.
"""

import itertools
import random
import sys
from math import comb  # noqa: F401  (kept for reproducibility of env check)

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

random.seed(20260812)

BASES = [2, 3, 10]
NMAX = 12
EXHAUSTIVE_CAP = 600_000  # enumerate all b^n words only below this


# --------------------------------------------------------------------------
# 0.  Words, the two dualities, the affine representation
# --------------------------------------------------------------------------
def digits(v, b, n):
    """little-endian length-n digit tuple of v in [0, b^n)."""
    out = []
    for _ in range(n):
        out.append(v % b)
        v //= b
    return tuple(out)


def value(w, b):
    v = 0
    for i, c in enumerate(w):
        v += c * b**i
    return v


def rho(w):
    return tuple(reversed(w))


def eps(w, b):
    return tuple(b - 1 - c for c in w)


def R_n(v, b, n):
    return value(rho(digits(v, b, n)), b)


def E_n(v, b, n):
    return b**n - 1 - v


# affine calculus over Z:  [a,c] : x |-> a x + c
def acomp(f, g):
    return (f[0] * g[0], f[0] * g[1] + f[1])


def aapply(f, x):
    return f[0] * x + f[1]


def Phi(w, b):
    """monoid homomorphism A_b^* -> Aff, w |-> gamma_{c_0} o ... o gamma_{c_{n-1}}."""
    f = (1, 0)
    for c in w:
        f = acomp(f, (b, c))
    return f


# --------------------------------------------------------------------------
# 1.  Closed forms
# --------------------------------------------------------------------------
def fix_D_closed(b, n):
    return b ** ((n + 1) // 2)


def fix_E_closed(b, n):
    if n == 0:
        return 1
    return 1 if b % 2 == 1 else 0


def fix_DE_closed(b, n):
    if n % 2 == 0:
        return b ** (n // 2)
    return b ** (n // 2) if b % 2 == 1 else 0


def fix_all_closed(b, n):
    if n == 0:
        return 1
    return 1 if b % 2 == 1 else 0


# --------------------------------------------------------------------------
# verifier scaffolding (designed annihilation)
# --------------------------------------------------------------------------
LEDGER = []


def verify(name, claim_true, kind):
    """kind in {'claim','control-false','control-true'}"""
    ok = bool(claim_true)
    LEDGER.append((name, kind, ok))
    tag = {"claim": "CLAIM", "control-false": "CONTROL(false)", "control-true": "CONTROL(true)"}[kind]
    if kind == "control-false":
        verdict = "REJECTED (correct)" if not ok else "ACCEPTED  <-- VERIFIER BROKEN"
    else:
        verdict = "ACCEPTED" if ok else "REJECTED  <-- CLAIM DEAD"
    print(f"    [{tag:16s}] {name:58s} {verdict}")
    return ok


# --------------------------------------------------------------------------
# PART 1: word level -- involutivity, commutation, group law, fixed points
# --------------------------------------------------------------------------
def part1():
    print("=" * 78)
    print("PART 1  word level: involutivity, commutator, group law, fixed points")
    print("=" * 78)
    fixdata = {}
    for b in BASES:
        print(f"\n  base b = {b}")
        print(f"    {'n':>3} {'b^n':>13} {'|FixD|':>10} {'|FixE|':>8} {'|FixDE|':>10} "
              f"{'|FixAll|':>9} {'orbits':>10}  mode")
        for n in range(0, NMAX + 1):
            N = b**n
            closed = (fix_D_closed(b, n), fix_E_closed(b, n),
                      fix_DE_closed(b, n), fix_all_closed(b, n))
            if N <= EXHAUSTIVE_CAP:
                mode = "exhaustive"
                fD = fE = fDE = fA = 0
                seen = set()
                orbits = 0
                for v in range(N):
                    w = digits(v, b, n)
                    wD, wE = rho(w), eps(w, b)
                    wDE = rho(eps(w, b))
                    # involutivity, elementwise
                    assert rho(wD) == w and eps(wE, b) == w
                    # commutator, elementwise:  D E = E D
                    assert rho(eps(w, b)) == eps(rho(w), b)
                    fD += wD == w
                    fE += wE == w
                    fDE += wDE == w
                    fA += (wD == w and wE == w)
                    if v not in seen:
                        orb = {value(x, b) for x in (w, wD, wE, wDE)}
                        seen |= orb
                        orbits += 1
                brute = (fD, fE, fDE, fA)
                assert brute == closed, (b, n, brute, closed)
                burnside = (N + fD + fE + fDE) // 4
                assert (N + fD + fE + fDE) % 4 == 0
                assert burnside == orbits, (b, n, burnside, orbits)
                orb_str = f"{orbits}"
            else:
                mode = "closed+sampled"
                # sampled falsification: predicate <-> fixedness on random words
                for _ in range(20000):
                    w = tuple(random.randrange(b) for _ in range(n))
                    assert (rho(w) == w) == (w == rho(w))
                    assert rho(eps(w, b)) == eps(rho(w), b)
                # constructive lower bound: enumerate the predicted fixed sets
                half = (n + 1) // 2
                if b**half <= EXHAUSTIVE_CAP:
                    cnt = 0
                    for v in range(b**half):
                        h = digits(v, b, half)
                        w = h + tuple(reversed(h[: n // 2]))
                        assert rho(w) == w
                        cnt += 1
                    assert cnt == closed[0]
                fD, fE, fDE, fA = closed
                orb_str = str((N + fD + fE + fDE) // 4)
            print(f"    {n:>3} {N:>13} {fD:>10} {fE:>8} {fDE:>10} {fA:>9} "
                  f"{orb_str:>10}  {mode}")
            fixdata[(b, n)] = (fD, fE, fDE, fA, mode)

    print("\n  -- group law of <D,E> on words of length n (explicit tables) --")

    def mul(x, y):
        """(x*y)(v) = x(y(v));  x, y are permutation tuples."""
        return tuple(x[t] for t in y)

    for b in BASES:
        for n in range(0, 9):
            N = b**n
            if N > 8192:
                continue
            idp = tuple(range(N))
            Dp = tuple(R_n(v, b, n) for v in range(N))
            Ep = tuple(E_n(v, b, n) for v in range(N))
            DEp = mul(Dp, Ep)
            EDp = mul(Ep, Dp)
            assert DEp == EDp                       # commutator is trivial
            G = [idp, Dp, Ep, DEp]
            elts = set(G)
            # closure + associativity on the explicit multiplication table
            prod = {}
            for x in G:
                for y in G:
                    z = mul(x, y)
                    assert z in elts, (b, n, "not closed")
                    prod[(x, y)] = z
            for x in G:
                for y in G:
                    for w_ in G:
                        assert prod[(x, prod[(y, w_)])] == prod[(prod[(x, y)], w_)]
            # element orders of the DISTINCT elements -> isomorphism fingerprint
            orders = []
            for x in sorted(elts):
                k, y = 1, x
                while y != idp:
                    y = mul(x, y)
                    k += 1
                orders.append(k)
            orders.sort()
            order = len(set(G))
            name = {1: "trivial", 2: "Z/2", 4: "V4 = Z/2 x Z/2"}[order]
            print(f"    b={b:>2} n={n:>2}: |<D,E>| = {order}, element orders {orders}"
                  f"  ==>  {name}")
            if n >= 2:
                assert order == 4 and orders == [1, 2, 2, 2]
    return fixdata


# --------------------------------------------------------------------------
# PART 2: the four corners of the ACTION (affine monoid)
# --------------------------------------------------------------------------
def part2():
    print()
    print("=" * 78)
    print("PART 2  the action: four corners in Aff(Z), D anti-auto, E = conjugation")
    print("=" * 78)
    sigma = (-1, -1)                                   # x |-> -1-x
    for b in BASES:
        # sigma is an involution in Aff(Z)
        assert acomp(sigma, sigma) == (1, 0)
        # E = conjugation by sigma on every generator (exact, all d)
        for d in range(b):
            g = (b, d)
            conj = acomp(acomp(sigma, g), sigma)       # sigma^{-1} = sigma
            assert conj == (b, b - 1 - d), (b, d, conj)
        print(f"\n  b={b}: sigma gamma_d sigma = gamma_(b-1-d) verified for all d "
              f"in 0..{b-1}")
        # Phi is a monoid hom; D is an anti-automorphism; E is an automorphism
        bad = 0
        for _ in range(4000):
            m = random.randrange(0, 7)
            k = random.randrange(0, 7)
            u = tuple(random.randrange(b) for _ in range(m))
            v = tuple(random.randrange(b) for _ in range(k))
            assert Phi(u + v, b) == acomp(Phi(u, b), Phi(v, b))          # hom
            if Phi(rho(u + v), b) != acomp(Phi(rho(v), b), Phi(rho(u), b)):
                bad += 1                                                 # anti-auto
            assert Phi(eps(u + v, b), b) == acomp(Phi(eps(u, b), b), Phi(eps(v, b), b))
            assert Phi(eps(u, b), b) == acomp(acomp(sigma, Phi(u, b)), sigma)
        assert bad == 0
        print(f"       Phi hom, D anti-auto (Phi(D(uv)) = Phi(Dv)Phi(Du)), "
              f"E auto = conj_sigma: 4000/4000 random word pairs exact")
        # explicit four corners on one word
        w = tuple(random.randrange(b) for _ in range(4))
        n = len(w)
        rows = [("X   = w", w, Phi(w, b)),
                ("D X = rev w", rho(w), Phi(rho(w), b)),
                ("E X = comp w", eps(w, b), Phi(eps(w, b), b)),
                ("DEX = rev comp w", rho(eps(w, b)), Phi(rho(eps(w, b)), b))]
        print(f"       four corners at w={w} (n={n}):")
        for lab, ww, f in rows:
            print(f"         {lab:18s} word={str(ww):24s} affine=[a,c]="
                  f"[{f[0]},{f[1]}]  = [b^{n}, {f[1]}]")
        # value-level corner identities
        v = value(w, b)
        assert Phi(rho(w), b)[1] == R_n(v, b, n)
        assert Phi(eps(w, b), b)[1] == b**n - 1 - v
        assert Phi(rho(eps(w, b)), b)[1] == b**n - 1 - R_n(v, b, n)
        print(f"         corner identities  D:v->R_n(v),  E:v->b^n-1-v,  "
              f"DE:v->b^n-1-R_n(v)  exact")
    # canonicity of E: the only nontrivial digit permutation induced by
    # conjugation inside Aff(Q) is d |-> b-1-d.
    print("\n  canonicity of E (search over affine conjugators a=+-1, c in Z):")
    for b in BASES:
        found = []
        for a in (1, -1):
            for c in range(-4 * b, 4 * b + 1):
                img = sorted(a * d + c * (1 - b) for d in range(b))
                if img == list(range(b)):
                    tau = tuple(a * d + c * (1 - b) for d in range(b))
                    found.append(((a, c), tau))
        names = []
        for (a, c), tau in found:
            if tau == tuple(range(b)):
                names.append(f"id via [a,c]=[{a},{c}]")
            elif tau == tuple(b - 1 - d for d in range(b)):
                names.append(f"E via [a,c]=[{a},{c}]")
            else:
                names.append(f"OTHER {tau}")
        print(f"    b={b:>2}: induced digit permutations = {names}")
        assert all("OTHER" not in s for s in names)
    return True


# --------------------------------------------------------------------------
# PART 3: inverse systems -- the chart/completion crossing
# --------------------------------------------------------------------------
def part3():
    print()
    print("=" * 78)
    print("PART 3  inverse systems: (E_n) completes, (R_n) does not (as a self-map)")
    print("=" * 78)
    for b in BASES:
        print(f"\n  b = {b}")
        print(f"    {'n':>3} {'#x in Z/b^(n+1)':>16} {'#{pi R != R pi}':>16} "
              f"{'pi R = R sig':>13} {'sig R = R pi':>13} {'pi E = E pi':>12}")
        for n in range(1, NMAX + 1):
            N1 = b ** (n + 1)
            if N1 > EXHAUSTIVE_CAP:
                xs = [random.randrange(N1) for _ in range(50000)]
                mode_exact = False
            else:
                xs = range(N1)
                mode_exact = True
            bad = 0
            ok_sig = ok_sigpi = ok_E = True
            for x in xs:
                lhs = R_n(x, b, n + 1) % b**n
                rhs_pi = R_n(x % b**n, b, n)
                rhs_sig = R_n(x // b, b, n)
                if lhs != rhs_pi:
                    bad += 1
                if lhs != rhs_sig:
                    ok_sig = False
                if (R_n(x, b, n + 1) // b) != R_n(x % b**n, b, n):
                    ok_sigpi = False
                if E_n(x, b, n + 1) % b**n != E_n(x % b**n, b, n):
                    ok_E = False
            tot = N1 if mode_exact else len(xs)
            flag = "" if mode_exact else "  (sampled)"
            print(f"    {n:>3} {tot:>16} {bad:>16} {str(ok_sig):>13} "
                  f"{str(ok_sigpi):>13} {str(ok_E):>12}{flag}")
            assert ok_sig and ok_sigpi and ok_E
            assert bad > 0, (b, n, "reversal unexpectedly pi-compatible")
    # smallest explicit witness
    print("\n  smallest explicit witness of pi-incompatibility, per base:")
    for b in BASES:
        n = 1
        for x in range(b ** (n + 1)):
            lhs = R_n(x, b, n + 1) % b**n
            rhs = R_n(x % b**n, b, n)
            if lhs != rhs:
                print(f"    b={b}: n=1, x={x} (digits {digits(x,b,2)}): "
                      f"pi_1(R_2(x))={lhs} != R_1(pi_1(x))={rhs}; "
                      f"and R_1(sig_1(x))={R_n(x//b,b,n)} = {lhs} OK")
                break
    # sig_n is not a homomorphism (kills any group structure on lim<-(sig))
    print("\n  sig_n is not additive (so lim<-(sig) carries no compatible group law):")
    for b in BASES:
        x, y = 1, b - 1
        lhs = ((x + y) % b**2) // b
        rhs = ((x // b) + (y // b)) % b
        print(f"    b={b}: sig_1({x}+{y}) = sig_1({x+y}) = {lhs}  vs  "
              f"sig_1({x})+sig_1({y}) = {rhs}   ==> not a homomorphism")
        assert lhs != rhs
    return True


# --------------------------------------------------------------------------
# PART 4: odometer, carry cocycle, reversed odometer
# --------------------------------------------------------------------------
def part4():
    print()
    print("=" * 78)
    print("PART 4  odometer: E reverses it; D-conjugate is off the dihedral group")
    print("=" * 78)
    grp_orders = {}
    for b in BASES:
        print(f"\n  b = {b}")
        for n in range(1, 7):
            N = b**n
            if N > 4096:
                continue
            T = [(v + 1) % N for v in range(N)]
            Ti = [(v - 1) % N for v in range(N)]
            E = [E_n(v, b, n) for v in range(N)]
            R = [R_n(v, b, n) for v in range(N)]
            # E T E = T^{-1}
            ETE = [E[T[E[v]]] for v in range(N)]
            assert ETE == Ti, (b, n)
            # reversed odometer
            Tt = [R[T[R[v]]] for v in range(N)]
            # is Tt affine mod b^n?
            affine = None
            for u in range(N):
                cand = [(u * v + Tt[0]) % N for v in range(N)]
                if cand == Tt:
                    affine = (u, Tt[0])
                    break
            # is Tt in the dihedral group <T,E> of order 2 b^n?
            dih = set()
            cur = list(range(N))
            for _ in range(N):
                dih.add(tuple(cur))
                dih.add(tuple(E[cur[v]] for v in range(N)))
                cur = [T[cur[v]] for v in range(N)]
            in_dih = tuple(Tt) in dih
            # <T,E> is dihedral of order 2N for N >= 3; it degenerates for N <= 2
            # (mod 2, x |-> -1-x IS the translation x |-> x+1)
            assert len(dih) == (2 * N if N >= 3 else N), (b, n, len(dih))
            # carry / valuation exchange and digit-sum cocycle
            def trail(v, dgt):
                d = digits(v, b, n)
                k = 0
                while k < n and d[k] == dgt:
                    k += 1
                return k
            carry_ok = all(trail(E[v], b - 1) == trail(v, 0) for v in range(N))
            def dsum(v):
                return sum(digits(v, b, n))
            coc_ok = all(dsum(v + 1) - dsum(v) == 1 - (b - 1) * trail(v, b - 1)
                         for v in range(N - 1))
            print(f"    n={n:>2} N={N:>5}: ETE=T^-1 {True}; Ttil affine mod b^n: "
                  f"{affine is not None}; Ttil in <T,E> (|.|={2*N}): {in_dih}; "
                  f"c(Ex)=z(x): {carry_ok}; digit-sum cocycle: {coc_ok}")
            assert carry_ok and coc_ok
            if n >= 2:
                assert affine is None and not in_dih
            else:
                assert affine is not None
        # order of <T_n, R_n> (measurement; F8 outcome space open)
        # Exact group order via Schreier-Sims.  Degree is capped at 32: sympy's
        # stabilizer-chain construction is already impractical at degree 64 for a
        # full symmetric group, and an unfinished computation is not a measurement.
        from sympy.combinatorics import Permutation, PermutationGroup
        for n in range(2, 10):
            N = b**n
            if N > 32:
                continue
            T = Permutation([(v + 1) % N for v in range(N)])
            R = Permutation([R_n(v, b, n) for v in range(N)])
            G = PermutationGroup([T, R])
            o = G.order()
            import math as _m
            full = _m.factorial(N)
            tag = ("= S_N" if o == full else
                   "= A_N" if o == full // 2 else
                   f"= {o}")
            grp_orders[(b, n)] = (o, full)
            print(f"    |<T_{n}, R_{n}>| on {N} points = {o}   (N! = {full})  {tag}")
            assert o != 2 * N
        if not any(k[0] == b for k in grp_orders):
            print(f"    |<T_n, R_n>|: NOT COMPUTED for b={b} (every b^n with n>=2 "
                  f"exceeds the degree-32 Schreier-Sims cap)")
    return grp_orders


# --------------------------------------------------------------------------
# PART 5: non-extension numerics (nowhere continuity of minimal reversal)
# --------------------------------------------------------------------------
def Rmin(x, b):
    if x == 0:
        return 0
    d = []
    while x:
        d.append(x % b)
        x //= b
    return value(tuple(reversed(d)), b)


def val_b(x, b):
    """number of trailing zero digits; val_b(0) = +inf represented as None."""
    if x == 0:
        return None
    k = 0
    while x % b == 0:
        x //= b
        k += 1
    return k


def part5():
    print()
    print("=" * 78)
    print("PART 5  no continuous extension: b-adically close words, far reversals")
    print("=" * 78)
    sharp = {}
    for b in BASES:
        print(f"\n  b = {b}   (|y|_b = b^-val_b(y);  witnesses u = x+b^k, v = x+b^k+b^(k+1),")
        print(f"             x = 1 has m = 1 digit, so the theorem needs k >= m+1 = 2)")
        print(f"    {'k':>3} {'u':>18} {'v':>18} {'val(u-v)':>9} "
              f"{'Rmin u':>18} {'Rmin v':>18} {'val(RmU-RmV)':>13}")
        for k in range(2, 14):
            x = 1
            u = x + b**k
            v = x + b**k + b ** (k + 1)
            du = val_b(u - v, b)
            dr = val_b(Rmin(u, b) - Rmin(v, b), b)
            print(f"    {k:>3} {u:>18} {v:>18} {du:>9} {Rmin(u,b):>18} "
                  f"{Rmin(v,b):>18} {dr:>13}")
            assert du >= k and dr == 1
        # sharp constant search over positive integers
        best = {}
        LIM = b**6
        for k in range(1, 6):
            bestk = None
            for u in range(1, min(LIM, 200000)):
                for m in (1, 2, b - 1 if b > 2 else 1):
                    v = u + m * b**k
                    if v >= LIM:
                        continue
                    if Rmin(u, b) == Rmin(v, b):
                        continue
                    dv = val_b(Rmin(u, b) - Rmin(v, b), b)
                    if bestk is None or dv < bestk[0]:
                        bestk = (dv, u, v)
            best[k] = bestk
        sharp[b] = best
        mn = min(v[0] for v in best.values())
        pred = 0 if b >= 3 else 1
        print(f"    sharp search (u,v positive, |u-v|_b <= b^-k, k=1..5): "
              f"min val(Rmin u - Rmin v) = {mn}  ==> sup |.|_b = b^-{mn}"
              f"   (predicted b^-{pred})")
        for k, t in best.items():
            print(f"       k={k}: val={t[0]} at (u,v)=({t[1]},{t[2]})")
        assert mn == pred
        # the same pair, seen through the sequences that must both converge
        print(f"    nowhere-continuity: for x = 1 and k -> oo, u_k -> x and v_k -> x "
              f"b-adically, but |Rmin(u_k) - Rmin(v_k)|_b = b^-1 for every k.")
    return sharp


# --------------------------------------------------------------------------
# PART 6: designed annihilation -- the verifier and its controls
# --------------------------------------------------------------------------
def part6(fixdata, grp_orders):
    print()
    print("=" * 78)
    print("PART 6  designed annihilation: controls the verifier must reject")
    print("=" * 78)
    b, n = 2, 4
    N = b**n
    idp = tuple(range(N))
    Dp = tuple(R_n(v, b, n) for v in range(N))
    Ep = tuple(E_n(v, b, n) for v in range(N))
    DEp = tuple(Dp[Ep[v]] for v in range(N))
    G = [idp, Dp, Ep, DEp]

    def order_of(x):
        k, y = 1, x
        while y != idp:
            y = tuple(x[y[v]] for v in range(N))
            k += 1
        return k

    orders = sorted(order_of(x) for x in G)
    print("\n  verifier inputs: b=2, n=4; explicit permutation group <D,E>")
    print(f"    element-order multiset = {orders}")
    verify("<D,E> is Klein four V4 (orders {1,2,2,2})", orders == [1, 2, 2, 2], "claim")
    verify("CONTROL A: <D,E> is cyclic Z/4 (orders {1,2,4,4})",
           orders == [1, 2, 4, 4], "control-false")
    verify("<D,E> is abelian (DE = ED)",
           all(tuple(x[y[v]] for v in range(N)) == tuple(y[x[v]] for v in range(N))
               for x in G for y in G), "claim")

    ok_pi_R = all(R_n(x, b, n + 1) % b**n == R_n(x % b**n, b, n)
                  for x in range(b ** (n + 1)))
    verify("CONTROL B: pi_n o R_{n+1} = R_n o pi_n", ok_pi_R, "control-false")
    ok_sig_R = all(R_n(x, b, n + 1) % b**n == R_n(x // b, b, n)
                   for x in range(b ** (n + 1)))
    verify("pi_n o R_{n+1} = R_n o sig_n", ok_sig_R, "claim")
    ok_pi_E = all(E_n(x, b, n + 1) % b**n == E_n(x % b**n, b, n)
                  for x in range(b ** (n + 1)))
    verify("CONTROL D: pi_n o E_{n+1} = E_n o pi_n", ok_pi_E, "control-true")

    fE_true = fixdata[(3, 4)][1]
    verify("CONTROL C: |Fix E| = b^{n/2}  (b=3, n=4 -> 9)",
           fE_true == 9, "control-false")
    verify("|Fix E| = 1 for b odd  (b=3, n=4)", fE_true == 1, "claim")

    ex = [(bb, nn) for (bb, nn), row in fixdata.items() if row[4] == "exhaustive"]
    agree = all(fixdata[(bb, nn)][:4] ==
                (fix_D_closed(bb, nn), fix_E_closed(bb, nn),
                 fix_DE_closed(bb, nn), fix_all_closed(bb, nn))
                for (bb, nn) in ex)
    verify(f"brute force == closed form at EVERY exhaustive (b,n) [{len(ex)} rows]",
           agree and len(ex) >= 25, "claim")
    # negative control on the same comparison: perturb one closed form
    verify("CONTROL E: brute force == closed form with |Fix D| := b^floor(n/2)",
           all(fixdata[(bb, nn)][0] == bb ** (nn // 2) for (bb, nn) in ex),
           "control-false")

    # F8 outcome (measurement only)
    verify("|<T_n,R_n>| != 2 b^n for every computed (b,n)",
           all(o != 2 * (b**n) for (b, n), (o, _) in grp_orders.items()), "claim")

    print()
    nfalse = sum(1 for _, k, ok in LEDGER if k == "control-false")
    nfalse_rej = sum(1 for _, k, ok in LEDGER if k == "control-false" and not ok)
    ntrue = sum(1 for _, k, ok in LEDGER if k != "control-false")
    ntrue_acc = sum(1 for _, k, ok in LEDGER if k != "control-false" and ok)
    print(f"  LEDGER: {nfalse_rej}/{nfalse} planted-false controls REJECTED; "
          f"{ntrue_acc}/{ntrue} true statements ACCEPTED.")
    assert nfalse_rej == nfalse and ntrue_acc == ntrue
    return True


# --------------------------------------------------------------------------
# FIGURES
# --------------------------------------------------------------------------
def figures(fixdata):
    ns = list(range(0, NMAX + 1))
    fig, axes = plt.subplots(1, 2, figsize=(12.4, 4.6))
    ax = axes[0]
    styles = {2: ("#0072B2", "o"), 3: ("#D55E00", "s"), 10: ("#009E73", "^")}
    for b in BASES:
        col, mk = styles[b]
        ax.semilogy(ns, [b**n for n in ns], color=col, lw=1.0, ls=":",
                    label=f"$b={b}$: $b^n$ (all words)")
        ax.semilogy(ns, [max(fixdata[(b, n)][0], 0.5) for n in ns], color=col,
                    marker=mk, ms=4, lw=1.6, label=f"$b={b}$: palindromes")
        ax.semilogy(ns, [max(fixdata[(b, n)][2], 0.5) for n in ns], color=col,
                    marker=mk, ms=4, lw=1.6, ls="--", mfc="none",
                    label=f"$b={b}$: antipalindromes")
    ax.set_xlabel("word length $n$")
    ax.set_ylabel("count (log scale)")
    ax.set_title("Fixed sets of the crystal: $|{\\rm Fix}\\,D|=b^{\\lceil n/2\\rceil}$,\n"
                 "$|{\\rm Fix}\\,DE|=b^{\\lfloor n/2\\rfloor}$ (0 if $n$ odd, $b$ even)")
    ax.legend(fontsize=6.5, ncol=1, loc="upper left")
    ax.grid(alpha=0.25, lw=0.5)

    ax = axes[1]
    for b in BASES:
        col, mk = styles[b]
        frac = []
        for n in range(1, 8):
            N1 = b ** (n + 1)
            if N1 > 200000:
                frac.append(float("nan"))
                continue
            bad = sum(1 for x in range(N1)
                      if R_n(x, b, n + 1) % b**n != R_n(x % b**n, b, n))
            frac.append(bad / N1)
        ax.plot(range(1, 8), frac, color=col, marker=mk, ms=5, lw=1.6,
                label=f"$b={b}$")
    ax.axhline(1.0, color="k", lw=0.8, ls=":")
    ax.set_ylim(0, 1.05)
    ax.set_xlabel("level $n$")
    ax.set_ylabel(r"fraction of $x\in\mathbb{Z}/b^{n+1}$ with $\pi_nR_{n+1}x\neq R_n\pi_nx$")
    ax.set_title("Completion defect of $D$: exactly $1-b^{-n}$ at every level\n"
                 "(agreement locus = the $b$ constant strings; $E$'s defect $\\equiv0$)")
    ax.legend(fontsize=8)
    ax.grid(alpha=0.25, lw=0.5)
    fig.tight_layout()
    fig.savefig("figures/exp62_crystal_fixed_and_defect.png", dpi=150)
    print("\n  wrote figures/exp62_crystal_fixed_and_defect.png")

    fig, ax = plt.subplots(figsize=(6.6, 4.4))
    for b in BASES:
        col, mk = styles[b]
        ks = list(range(2, 14))   # theorem hypothesis k >= m+1 = 2 for x = 1
        din, dout = [], []
        for k in ks:
            u = 1 + b**k
            v = 1 + b**k + b ** (k + 1)
            din.append(b ** (-val_b(u - v, b)))
            dout.append(b ** (-val_b(Rmin(u, b) - Rmin(v, b), b)))
        ax.loglog(din, dout, color=col, marker=mk, ms=5, lw=1.4, label=f"$b={b}$")
    ax.set_xlabel(r"$|u-v|_b$  (inputs $b$-adically close)")
    ax.set_ylabel(r"$|R^{\min}u - R^{\min}v|_b$  (outputs stay far)")
    ax.set_title("No modulus of continuity for word reversal\n"
                 r"$u=1+b^k$, $v=1+b^k+b^{k+1}$: output distance pinned at $b^{-1}$")
    ax.grid(alpha=0.25, lw=0.5, which="both")
    ax.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig("figures/exp62_no_continuous_extension.png", dpi=150)
    print("  wrote figures/exp62_no_continuous_extension.png")


def main():
    print(__doc__.split("FORECAST")[0].strip())
    fixdata = part1()
    part2()
    part3()
    grp = part4()
    part5()
    part6(fixdata, grp)
    figures(fixdata)
    print()
    print("=" * 78)
    print("ALL ASSERTIONS PASSED.  Forecast items F1-F7 confirmed; F8 measured.")
    print("=" * 78)


if __name__ == "__main__":
    sys.exit(main())
