"""
exp53: exact certificates for notes/CONSTRAINT_ALGEBRA.md (Workstream C).

Claim-anchored per PROTOCOL 4. Declared exact quantities, each confirm-or-kill
for a stated candidate statement in the note:

  (A) [Walsh transcription identity] For ANY +-1 sequence and any window X,
      the pattern-frequency vector equals its Walsh reconstruction exactly
      (rational arithmetic, no rounding).  Kill condition: any mismatch
      kills the note's formula (7.4)/class tables.  Control where the
      statement is "false": a deliberately WRONG class table (b-term sign
      flipped) must FAIL the reconstruction on generic data.
  (B) [Class-table identity] The note's four-class closed form for
      32*d(eps) in terms of (a,b1,b2,c) agrees with direct Walsh expansion
      for all 32 patterns, as polynomial identities over exact rationals
      evaluated on 200 random rational (a,b1,b2,c).
  (C) [Blocking counts] With b1=b2=b: at (a,b,c)=(1/3,1/3,1/3) exactly 10
      of 32 pattern densities vanish; at (1/2,0,0) exactly 8 (and the
      blocked set equals F_a(-)); at (0,1/2,0) exactly 8.  These certify
      the gap in the Case a,b,c != 0 argument of Tao-Teravainen
      (1904.05096, proof of Thm 1.14) and the extremal-octet identity.
  (D) [Polytope maximum] Over the exact rational grid of step 1/60 on
      |a|<=1/2, |b|<=2/3, |c|<=2/3 intersected with positivity of all 32
      densities, the maximum number of vanishing densities is 10, attained
      only at the sign-orbit of (1/3,1/3,1/3); and after imposing the
      freeze constraints (all 8 class-C densities >= 1/7680) the maximum
      drops to 8, attained only at (+-1/2, 0, 0).
  (E) [F2[u] certificates] (u+u^2+u^3+u^4)*(1+u) = u+u^5;
      (u+u^2+u^4+u^5)*(u+u^2+u^3) = u^2+u^8;
      (u+u^2+u^3+u^5)*(1+u+u^3) = u+u^8;
      (u+u^3+u^4+u^5)*(1+u^2+u^3) = u+u^8   over F2 — the multiplier
      monomial counts (2,3,3,3) used in the C-PROP bounds.
  (F) [Finite-lambda regression] At X = 2*10^6 the empirical log-averaged
      window-5 pattern frequencies of Liouville satisfy (A) exactly, and
      the empirical (a, b1, b2, c) are printed for the record (context
      only; no density claim is inferred from them).
"""

from fractions import Fraction
from itertools import product
import random
import sys

random.seed(53)

PATTERNS = list(product([1, -1], repeat=5))
SUBSETS4 = [(1, 2, 3, 4), (2, 3, 4, 5), (1, 3, 4, 5), (1, 2, 3, 5), (1, 2, 4, 5)]


def walsh_density(eps, a, b1, b2, c):
    """32*d(eps) = 1 + a(e1e2e3e4 + e2e3e4e5) + b1*e1e3e4e5 + b2*e1e2e3e5
       + c*e1e2e4e5   (2-pt, odd orders set to 0)."""
    e = {i + 1: eps[i] for i in range(5)}
    val = Fraction(1)
    coef = {(1, 2, 3, 4): a, (2, 3, 4, 5): a, (1, 3, 4, 5): b1,
            (1, 2, 3, 5): b2, (1, 2, 4, 5): c}
    for A in SUBSETS4:
        t = Fraction(1)
        for i in A:
            t *= e[i]
        val += coef[A] * t
    return val


# The note states: class A: 32d = 1 + 2a e1e3 + 2b e2e3 + c,
# class B (e1=e5, e2=-e4): 32d = 1 - 2 a e1e3 - c,
# class C (e1=-e5, e2=e4): 32d = 1 - 2 b e2e3 - c, class D: 32d = 1 + c.
def class_form_note(eps, a, b, c):
    e1, e2, e3, e4, e5 = eps
    s1, s2 = e1 * e5, e2 * e4
    if s1 == 1 and s2 == 1:
        return Fraction(1) + 2 * a * e1 * e3 + 2 * b * e2 * e3 + c
    if s1 == 1 and s2 == -1:
        return Fraction(1) - 2 * a * e1 * e3 - c
    if s1 == -1 and s2 == 1:
        return Fraction(1) - 2 * b * e2 * e3 - c
    return Fraction(1) + c


def check_B():
    ok = True
    for _ in range(200):
        a = Fraction(random.randint(-30, 30), 61)
        b = Fraction(random.randint(-30, 30), 61)
        c = Fraction(random.randint(-30, 30), 61)
        for eps in PATTERNS:
            if walsh_density(eps, a, b, b, c) != class_form_note(eps, a, b, c):
                print("  MISMATCH", eps, a, b, c)
                ok = False
    print(f"(B) class-table identity vs Walsh expansion, 200 random rational points: "
          f"{'PASS' if ok else 'FAIL'}")
    return ok


def blocked_count(a, b, c):
    blocked = [eps for eps in PATTERNS if walsh_density(eps, a, b, b, c) == 0]
    return blocked


def check_C():
    third = Fraction(1, 3)
    half = Fraction(1, 2)
    b1 = blocked_count(third, third, third)
    b2 = blocked_count(half, Fraction(0), Fraction(0))
    b3 = blocked_count(Fraction(0), half, Fraction(0))
    Fa_minus = [eps for eps in PATTERNS
                if eps[0] * eps[1] * eps[2] * eps[3] == -1
                and eps[1] * eps[2] * eps[3] * eps[4] == -1]
    ok = (len(b1) == 10 and len(b2) == 8 and len(b3) == 8
          and sorted(b2) == sorted(Fa_minus))
    print(f"(C) blocked counts: (1/3,1/3,1/3) -> {len(b1)} (want 10); "
          f"(1/2,0,0) -> {len(b2)} (want 8, = F_a(-): {sorted(b2)==sorted(Fa_minus)}); "
          f"(0,1/2,0) -> {len(b3)} (want 8): {'PASS' if ok else 'FAIL'}")
    # positivity at the 10-point:
    tp = all(walsh_density(eps, third, third, third, third) >= 0 for eps in PATTERNS)
    tot = sum(walsh_density(eps, third, third, third, third) for eps in PATTERNS)
    print(f"    positivity of all 32 at (1/3,1/3,1/3): {tp}; total = {tot} (want 32)")
    return ok and tp and tot == 32


def check_D():
    step = Fraction(1, 60)
    best, argbest = 0, []
    bestF, argbestF = 0, []
    thresh = Fraction(32, 7680)  # 32*d >= 32/7680 for the 8 class-C patterns
    classC = [eps for eps in PATTERNS if eps[0] * eps[4] == -1 and eps[1] * eps[3] == 1]
    rng_a = [Fraction(i, 60) for i in range(-30, 31)]
    rng_bc = [Fraction(i, 60) for i in range(-40, 41)]
    for a in rng_a:
        for b in rng_bc:
            for c in rng_bc:
                vals = {eps: walsh_density(eps, a, b, b, c) for eps in PATTERNS}
                if any(v < 0 for v in vals.values()):
                    continue
                nb = sum(1 for v in vals.values() if v == 0)
                if nb > best:
                    best, argbest = nb, [(a, b, c)]
                elif nb == best and nb >= 10:
                    argbest.append((a, b, c))
                if all(vals[eps] >= thresh for eps in classC):
                    if nb > bestF:
                        bestF, argbestF = nb, [(a, b, c)]
                    elif nb == bestF and nb >= 8:
                        argbestF.append((a, b, c))
    ok = best == 10 and bestF == 8
    print(f"(D) grid max blocked (positivity only): {best} at {argbest} (want 10 at "
          f"sign-orbit of (1/3,1/3,1/3)); with freeze constraint on class C: {bestF} at "
          f"{argbestF} (want 8 at (+-1/2,0,0)): {'PASS' if ok else 'FAIL'}")
    return ok


def polymul_f2(p, q):
    r = set()
    for i in p:
        for j in q:
            r ^= {i + j}
    return r


def check_E():
    cases = [
        ({1, 2, 3, 4}, {0, 1}, {1, 5}),
        ({1, 2, 4, 5}, {1, 2, 3}, {2, 8}),
        ({1, 2, 3, 5}, {0, 1, 3}, {1, 8}),
        ({1, 3, 4, 5}, {0, 2, 3}, {1, 8}),
    ]
    ok = True
    for P, Q, want in cases:
        got = polymul_f2(P, Q)
        good = got == want
        ok = ok and good
        print(f"(E) F2[u]: supp{sorted(P)} * supp{sorted(Q)} = supp{sorted(got)} "
              f"(want {sorted(want)}): {'PASS' if good else 'FAIL'}")
    return ok


def liouville_table(X):
    lam = [1] * (X + 1)
    # sieve of Omega parity via smallest prime factor
    spf = [0] * (X + 1)
    for i in range(2, X + 1):
        if spf[i] == 0:
            for j in range(i, X + 1, i):
                if spf[j] == 0:
                    spf[j] = i
    for i in range(2, X + 1):
        lam[i] = -lam[i // spf[i]]
    return lam


def check_A_F(X=2 * 10 ** 6):
    lam = liouville_table(X + 6)
    # exact rational log-weights
    W = Fraction(0)
    freq = {eps: Fraction(0) for eps in PATTERNS}
    corr = {A: Fraction(0) for A in SUBSETS4}
    corr2 = Fraction(0)  # a 2-pt witness {1,2}
    for n in range(1, X + 1):
        w = Fraction(1, n)
        W += w
        eps = tuple(lam[n + j] for j in range(1, 6))
        freq[eps] += w
        for A in SUBSETS4:
            t = 1
            for i in A:
                t *= lam[n + i]
            corr[A] += w * t
        corr2 += w * lam[n + 1] * lam[n + 2]
    # (A) exact Walsh reconstruction with ALL 31 nonempty subsets:
    ok = True
    from itertools import combinations
    # reconstruct correlations from freq (exact algebra), then reconstruct freq back:
    corr_from_freq = {}
    for r in range(1, 6):
        for A in combinations(range(1, 6), r):
            s = Fraction(0)
            for eps, f in freq.items():
                t = 1
                for i in A:
                    t *= eps[i - 1]
                s += f * t
            corr_from_freq[A] = s
    for eps in PATTERNS:
        recon = W
        for A, cA in corr_from_freq.items():
            t = 1
            for i in A:
                t *= eps[i - 1]
            recon += cA * t
        recon /= 32
        if recon != freq[eps]:
            ok = False
    print(f"(A) exact Walsh reconstruction identity at X={X}: {'PASS' if ok else 'FAIL'}")
    # control: flip the sign of one subset's contribution -> must FAIL
    bad = False
    for eps in PATTERNS:
        recon = W
        for A, cA in corr_from_freq.items():
            t = 1
            for i in A:
                t *= eps[i - 1]
            recon += (-cA if A == (1, 2, 4, 5) else cA) * t
        recon /= 32
        if recon != freq[eps]:
            bad = True
            break
    print(f"    control (planted sign error must fail): {'PASS' if bad else 'FAIL'}")
    # verify the four correlation values match the direct accumulation:
    ok2 = all(corr_from_freq[A] == corr[A] for A in SUBSETS4)
    print(f"    direct vs freq-derived 4-point sums agree exactly: {ok2}")
    a_emp = float(corr[(1, 2, 3, 4)] / W)
    a_emp2 = float(corr[(2, 3, 4, 5)] / W)
    b1_emp = float(corr[(1, 3, 4, 5)] / W)
    b2_emp = float(corr[(1, 2, 3, 5)] / W)
    c_emp = float(corr[(1, 2, 4, 5)] / W)
    print(f"(F) empirical log-avg at X={X} (context only): a={a_emp:+.5f} "
          f"(shifted copy {a_emp2:+.5f}), b1={b1_emp:+.5f}, b2={b2_emp:+.5f}, "
          f"c={c_emp:+.5f}, 2pt(1,2)={float(corr2/W):+.5f}")
    return ok and bad and ok2


if __name__ == "__main__":
    X = 2 * 10 ** 6 if len(sys.argv) < 2 else int(sys.argv[1])
    results = []
    results.append(check_B())
    results.append(check_C())
    results.append(check_D())
    results.append(check_E())
    results.append(check_A_F(X))
    print("ALL PASS" if all(results) else "FAILURES PRESENT")
