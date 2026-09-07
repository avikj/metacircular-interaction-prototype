#!/usr/bin/env python3
"""exp61 -- the rational circle as a five-chart atlas, with checked transition
maps, an exact residual/fiber theorem, and chart-vs-ambient Diophantine
geometry.

Executes PYTHAGOREAN_EUCLIDEAN_MACHINE.md sections 4 (reachable points and the
beyond) and 6 (polyglot atlas) on the note's own canonical model, S^1(Q).

Charts
------
  (1) PT   primitive Pythagorean triples (a,b,c), a odd, b even, a,b,c>0
  (2) T    tangent half-angle t = n/m in Q, stereographic parametrization
  (3) Z    primitive Gaussian integers z = m + i n modulo {+-1}
  (4) BH   Barning--Hall ternary words in {A,B,C}*
  (5) CF   continued fraction / Stern--Brocot address of t

Everything below is exact integer / Fraction arithmetic except the explicitly
labelled Diophantine measurements (float64 angles).

Designed annihilation (PROTOCOL.md sec.7, msg 0073): every structural claim is
paired with a planted-false variant that the same verifier must REJECT.  Search
for "CONTROL" below.

Author: Weaver fleet, atlas lane.  Namespace exp61.  New files only.
"""

import json
import math
import os
import random
import sys
from fractions import Fraction
from math import gcd

import numpy as np

# ---------------------------------------------------------------------------
# configuration
# ---------------------------------------------------------------------------
CMAX = 100_000            # hypotenuse bound for the exact atlas verification
SEED = 20260812
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.join(ROOT, "data")
FIGS = os.path.join(ROOT, "figures")

LOG = []


def say(*a):
    s = " ".join(str(x) for x in a)
    LOG.append(s)
    print(s, flush=True)


FAILURES = []


def check(name, cond, detail=""):
    if cond:
        say(f"  [OK]     {name}" + (f"  {detail}" if detail else ""))
    else:
        say(f"  [FAIL]   {name}  {detail}")
        FAILURES.append(name)
    return cond


def check_rejects(name, cond, detail=""):
    """A planted-false claim: `cond` is the verifier's verdict; we require it
    to be False, i.e. the verifier must reject."""
    if not cond:
        say(f"  [REJECTED-AS-DESIGNED] {name}" + (f"  {detail}" if detail else ""))
    else:
        say(f"  [CONTROL-FAILED] {name} was ACCEPTED but is false  {detail}")
        FAILURES.append("CONTROL " + name)
    return not cond


# ===========================================================================
# 0.  Chart 1 <-> Chart 2: Euclid enumeration
# ===========================================================================
say("=" * 74)
say("exp61  rational circle atlas   CMAX =", CMAX)
say("=" * 74)
say("")
say("[0] Chart 1 (primitive triples) and chart 2 (t = n/m), Euclid enumeration")

triples = []          # (a,b,c) a odd, b even
mn_of = {}            # (a,b,c) -> (m,n)
m_top = int(math.isqrt(CMAX))
for m in range(2, m_top + 1):
    for n in range(1, m):
        if (m + n) % 2 == 0:
            continue
        if gcd(m, n) != 1:
            continue
        c = m * m + n * n
        if c > CMAX:
            break
        a = m * m - n * n
        b = 2 * m * n
        triples.append((a, b, c))
        mn_of[(a, b, c)] = (m, n)
triples.sort(key=lambda T: (T[2], T[0]))
NT = len(triples)
say(f"  primitive triples with c <= {CMAX}: {NT}")
say(f"  Lehmer 1900 asymptotic  c_max/(2*pi) = {CMAX/(2*math.pi):.1f}"
    f"   ratio measured/predicted = {NT/(CMAX/(2*math.pi)):.5f}")

check("all triples satisfy a^2+b^2=c^2, gcd=1, a odd, b even",
      all(a * a + b * b == c * c and gcd(gcd(a, b), c) == 1
          and a % 2 == 1 and b % 2 == 0 for a, b, c in triples))
check("triples pairwise distinct", len(set(triples)) == NT)


def triple_to_t(T):
    """Chart 1 -> chart 2.  The *Euclid* branch: t with m+n odd."""
    a, b, c = T
    # t = tan(theta/2) = y/(1+x) = (b/c)/(1 + a/c) = b/(c+a)
    return Fraction(b, c + a)


def t_to_triple(t):
    """Chart 2 -> chart 1, on the Euclid domain 0<n<m, gcd=1, m+n odd."""
    n, m = t.numerator, t.denominator
    return (m * m - n * n, 2 * m * n, m * m + n * n)


# round trips
bad = 0
for T in triples:
    t = triple_to_t(T)
    m, n = t.denominator, t.numerator
    if (m, n) != mn_of[T] or t_to_triple(t) != T:
        bad += 1
check("chart1 <-> chart2 round trip on all triples (Euclid branch)", bad == 0,
      f"{NT} triples")

# the *second* branch: the both-odd fraction, image of t under t -> (1-t)/(1+t)
bad = 0
for T in triples[:20000]:
    t = triple_to_t(T)
    s = (1 - t) / (1 + t)
    p, q = s.numerator, s.denominator
    if not (p % 2 == 1 and q % 2 == 1):
        bad += 1
        continue
    # both-odd branch: triple is (pq, (q^2-p^2)/2, (p^2+q^2)/2)
    a2, b2, c2 = p * q, (q * q - p * p) // 2, (p * p + q * q) // 2
    if (a2, b2, c2) != T:
        bad += 1
check("chart2 both-odd branch t -> (1-t)/(1+t) recovers the same triple",
      bad == 0, "leg-swap involution, 20000 triples")

# CONTROL: the planted-false claim that the Euclid branch is a bijection onto
# ALL reduced fractions in (0,1) (i.e. that the parity condition is vacuous).
frac_euclid = set()
frac_all = set()
for T in triples[:5000]:
    t = triple_to_t(T)
    frac_euclid.add((t.numerator, t.denominator))
for m in range(2, 60):
    for n in range(1, m):
        if gcd(m, n) == 1:
            frac_all.add((n, m))
sub = {f for f in frac_all if f[1] <= 59}
check_rejects("CONTROL-A  'Euclid domain = all reduced fractions in (0,1)'",
              sub <= frac_euclid,
              f"both-odd fractions omitted, e.g. {sorted(f for f in sub if f not in frac_euclid)[:3]}")


# ===========================================================================
# 1.  Chart 3: Gaussian integers, and the D4 residual/fiber theorem
# ===========================================================================
say("")
say("[1] Chart 3 (Z[i]) and the residual group")


def gmul(u, v):
    return (u[0] * v[0] - u[1] * v[1], u[0] * v[1] + u[1] * v[0])


def gconj(u):
    return (u[0], -u[1])


def gdivexact(u, v):
    """exact division in Z[i]; returns None if v does not divide u."""
    nv = v[0] * v[0] + v[1] * v[1]
    num = gmul(u, gconj(v))
    if num[0] % nv or num[1] % nv:
        return None
    return (num[0] // nv, num[1] // nv)


bad = 0
for T in triples:
    a, b, c = T
    m, n = mn_of[T]
    z = (m, n)
    z2 = gmul(z, z)
    if z2 != (a, b):
        bad += 1
check("chart3 -> chart1:  z = m+in  =>  z^2 = a+ib  exactly", bad == 0)

# --- the D4 action on S^1(Q) and the fiber count -------------------------
# r : w -> i*w      (rotation by pi/2)     s : w -> conj(w) = w^{-1}
# D4 = <r,s>, order 8.  Represent a point of S^1(Q) as an exact pair (a,b,c)
# with a^2+b^2=c^2, gcd(a,b,c)=1, c>0 (signs on a,b allowed, and a may be even).

def d4_orbit(a, b, c):
    out = set()
    x, y = a, b
    for _ in range(4):
        out.add((x, y, c))
        out.add((x, -y, c))
        x, y = -y, x          # multiply by i
    return out


pts = set()
for (a, b, c) in triples:
    pts |= d4_orbit(a, b, c)
pts |= {(1, 0, 1), (-1, 0, 1), (0, 1, 1), (0, -1, 1)}
NP = len(pts)
say(f"  rational points with height c <= {CMAX}: {NP}")
check("fiber identity  |S^1(Q)_{<=H}| = 8*|PT_{<=H}| + 4", NP == 8 * NT + 4,
      f"{NP} == 8*{NT}+4 = {8*NT+4}")

orbit_sizes = {}
seen = set()
for p in pts:
    if p in seen:
        continue
    o = d4_orbit(*p)
    seen |= o
    orbit_sizes[len(o)] = orbit_sizes.get(len(o), 0) + 1
say(f"  D4 orbit size census: {orbit_sizes}")
check("exactly one non-free D4 orbit, of size 4 (= mu_4)",
      orbit_sizes.get(4, 0) == 1 and set(orbit_sizes) == {4, 8})
check("number of free orbits equals number of primitive triples",
      orbit_sizes.get(8, 0) == NT)

# stabilizers, computed elementwise
stab_counts = {}
for p in pts:
    a, b, c = p
    st = 0
    for k in range(4):
        for eps in (1, -1):
            x, y = a, eps * b
            for _ in range(k):
                x, y = -y, x
            if (x, y, c) == p:
                st += 1
    stab_counts[st] = stab_counts.get(st, 0) + 1
check("stabilizer orders are 1 (generic) and 2 (on mu_4 only)",
      set(stab_counts) <= {1, 2} and stab_counts.get(2, 0) == 4,
      str(stab_counts))

# CONTROL: planted-false fiber size 4
check_rejects("CONTROL-B  'the fiber of PT <- S^1(Q) has size 4'",
              NP == 4 * NT + 4, f"true count {NP} != {4*NT+4}")

# the rotation r is realised on the Gaussian chart by multiplication by (1+i)
bad = 0
for T in triples[:20000]:
    m, n = mn_of[T]
    z = (m, n)
    zz = gmul((1, 1), z)                  # (1+i) z
    # w = z/zbar ;  w' = zz/conj(zz) should equal i*w
    # compare as exact integer pairs after clearing denominators
    w = gmul(z, z)                        # numerator of z/zbar times |z|^2
    Nz = m * m + n * n
    w2 = gmul(zz, zz)
    Nzz = 2 * Nz
    lhs = (Fraction(w2[0], Nzz), Fraction(w2[1], Nzz))
    iw = (-Fraction(w[1], Nz), Fraction(w[0], Nz))
    if lhs != iw:
        bad += 1
check("multiplication by the ramified prime (1+i) on Z[i] induces w -> i*w",
      bad == 0, "20000 triples")

bad = 0
for T in triples[:20000]:
    m, n = mn_of[T]
    Nz = m * m + n * n
    w = gmul((m, n), (m, n))
    zb = gconj((m, n))
    wb = gmul(zb, zb)
    # conj(z)/z  should be w^{-1} = conj(w) since |w|=1
    if (Fraction(wb[0], Nz), Fraction(wb[1], Nz)) != (Fraction(w[0], Nz), -Fraction(w[1], Nz)):
        bad += 1
check("Gaussian conjugation induces w -> w^{-1}", bad == 0)


# ===========================================================================
# 2.  Chart 4: Barning--Hall ternary tree
# ===========================================================================
say("")
say("[2] Chart 4 (Barning--Hall ternary words)")

MA = ((1, -2, 2), (2, -1, 2), (2, -2, 3))
MB = ((1, 2, 2), (2, 1, 2), (2, 2, 3))
MC = ((-1, 2, 2), (-2, 1, 2), (-2, 2, 3))
MATS = {"A": MA, "B": MB, "C": MC}


def apply_mat(M, T):
    return tuple(sum(M[i][j] * T[j] for j in range(3)) for i in range(3))


say(f"  A(3,4,5) = {apply_mat(MA,(3,4,5))}")
say(f"  B(3,4,5) = {apply_mat(MB,(3,4,5))}")
say(f"  C(3,4,5) = {apply_mat(MC,(3,4,5))}")
say("  (label convention differs across sources; ours is fixed by these images)")


def bh_word(T):
    """Descend to the root, returning the word w with w.(3,4,5) = T.

    Descent rule in Euclid coordinates (M,N), M>N>0:
       N > M/2  -> child A, parent (N, 2N-M)
       M/3<N<M/2-> child B, parent (N, M-2N)
       N < M/3  -> child C, parent (M-2N, N)
    """
    M, N = mn_of[T]
    letters = []
    while (M, N) != (2, 1):
        if 2 * N > M:
            letters.append("A")
            M, N = N, 2 * N - M
        elif 3 * N > M:
            letters.append("B")
            M, N = N, M - 2 * N
        else:
            letters.append("C")
            M, N = M - 2 * N, N
    return "".join(reversed(letters))


def bh_eval(word):
    T = (3, 4, 5)
    for ch in word:
        T = apply_mat(MATS[ch], T)
    return T


words = {}
bad = 0
for T in triples:
    w = bh_word(T)
    if bh_eval(w) != T:
        bad += 1
    words[T] = w
check("Barning--Hall: descent word re-evaluates to the triple", bad == 0,
      f"{NT} triples")
check("Barning--Hall words are pairwise distinct (injectivity)",
      len(set(words.values())) == NT)

# surjectivity on the enumerated range: every word whose value has c<=CMAX
# is realised.  Equivalently the word set is prefix-closed.
wset = set(words.values())
check("word set is prefix-closed (tree completeness on the range)",
      all(w[:k] in wset for w in list(wset)[:5000] for k in range(len(w))))
depth = {}
for w in wset:
    depth[len(w)] = depth.get(len(w), 0) + 1
say(f"  depth census (levels 0..12): "
    f"{[depth.get(k, 0) for k in range(13)]}  ... max depth {max(depth)}")
kfull = max(k for k in range(0, 30) if all(depth.get(j, 0) == 3 ** j
                                           for j in range(k + 1)))
check("levels 0..5 are complete ternary (3^k nodes); deeper levels are"
      " truncated by the c<=CMAX window",
      kfull >= 5, f"complete through level {kfull}; "
      f"level {kfull+1} has {depth.get(kfull+1,0)}/{3**(kfull+1)}")

# the (m,n) form of the three moves
MNA = ((2, -1), (1, 0))
MNB = ((2, 1), (1, 0))
MNC = ((1, 2), (0, 1))
bad = 0
for T in triples[:20000]:
    m, n = mn_of[T]
    for lab, MM in (("A", MNA), ("B", MNB), ("C", MNC)):
        M2 = MM[0][0] * m + MM[0][1] * n
        N2 = MM[1][0] * m + MM[1][1] * n
        child = (M2 * M2 - N2 * N2, 2 * M2 * N2, M2 * M2 + N2 * N2)
        if child != apply_mat(MATS[lab], T):
            bad += 1
check("(m,n)-form of the three moves agrees with the 3x3 matrices", bad == 0)

# CONTROL: planted-false Barning--Hall matrix (last entry 3 -> 2)
MA_FALSE = ((1, -2, 2), (2, -1, 2), (2, -2, 2))


def is_prim_triple(T):
    a, b, c = T
    return (a > 0 and b > 0 and c > 0 and a * a + b * b == c * c
            and gcd(gcd(a, b), c) == 1)


nbad_false = sum(1 for T in triples[:2000] if not is_prim_triple(apply_mat(MA_FALSE, T)))
check_rejects("CONTROL-C  'A' = A with entry (3,3)=2 also generates triples'",
              nbad_false == 0,
              f"{nbad_false}/2000 images are not Pythagorean; e.g. "
              f"A'(3,4,5) = {apply_mat(MA_FALSE,(3,4,5))}")


# ===========================================================================
# 3.  Chart 5: continued fractions / Stern--Brocot
# ===========================================================================
say("")
say("[3] Chart 5 (continued fraction / Stern--Brocot address)")


def cf_of(t):
    """canonical CF of t = n/m in (0,1): returns [a1,...,ak] with ak>=2."""
    n, m = t.numerator, t.denominator
    out = []
    while n:
        q, r = divmod(m, n)
        out.append(q)
        m, n = n, r
    return out


def cf_value(L):
    v = Fraction(L[-1])
    for a in reversed(L[:-1]):
        v = a + 1 / v
    return 1 / v


def cf_normalize(L):
    """put a CF tail into canonical form: all a_i >= 1 and a_k >= 2.

    Two rewrites, both value-preserving:
       [.., x, 0, y, ..] -> [.., x+y, ..]       (zero collapse)
       [.., x, 1]        -> [.., x+1]           (trailing-one collapse)
    """
    L = list(L)
    changed = True
    while changed:
        changed = False
        for i, a in enumerate(L):
            if a == 0:
                assert 0 < i < len(L) - 1, f"degenerate CF {L}"
                L = L[:i - 1] + [L[i - 1] + L[i + 1]] + L[i + 2:]
                changed = True
                break
        if not changed and len(L) > 1 and L[-1] == 1:
            L = L[:-2] + [L[-2] + 1]
            changed = True
    return L


def cf_move(letter, L):
    """symbolic Barning--Hall move on the CF tail L = [a1,...,ak]."""
    if letter == "A":
        return cf_normalize([1, 1, L[0] - 1] + L[1:])
    if letter == "B":
        return cf_normalize([2] + L)
    if letter == "C":
        return cf_normalize([L[0] + 2] + L[1:])
    raise ValueError(letter)


def cf_from_word(word):
    L = [2]                       # root t = 1/2 = [0;2]
    for ch in word:
        L = cf_move(ch, L)
    return L


bad = 0
for T in triples:
    t = triple_to_t(T)
    L = cf_of(t)
    if cf_value(L) != t:
        bad += 1
check("CF round trip  t -> [a1..ak] -> t", bad == 0, f"{NT} fractions")

bad, ex = 0, None
for T in triples:
    t = triple_to_t(T)
    pred = cf_from_word(words[T])
    act = cf_of(t)
    if pred != act:
        bad += 1
        ex = ex or (T, words[T], pred, act)
check("BH word -> CF dictionary  A:[1,1,a1-1,..]  B:[2,a1,..]  C:[a1+2,..]",
      bad == 0, f"{NT} triples" if bad == 0 else f"{bad} mismatches, e.g. {ex}")

# CONTROL: planted-false CF rule for A (a1 instead of a1-1)
def cf_move_false(letter, L):
    if letter == "A":
        return cf_normalize([1, 1] + L)
    return cf_move(letter, L)


def cf_from_word_false(word):
    L = [2]
    for ch in word:
        L = cf_move_false(ch, L)
    return L


nb = sum(1 for T in triples[:3000] if cf_from_word_false(words[T]) != cf_of(triple_to_t(T)))
check_rejects("CONTROL-D  'A acts on the CF by prepending [1,1] verbatim'",
              nb == 0, f"{nb}/3000 mismatches")

# --- Stern--Brocot L/R address -------------------------------------------

def sb_address(t):
    lo_n, lo_m, hi_n, hi_m = 0, 1, 1, 1
    out = []
    while True:
        mn, mm = lo_n + hi_n, lo_m + hi_m
        if Fraction(mn, mm) == t:
            return "".join(out)
        if t < Fraction(mn, mm):
            out.append("L")
            hi_n, hi_m = mn, mm
        else:
            out.append("R")
            lo_n, lo_m = mn, mm


def sb_from_cf(L):
    """L^{a1-1} R^{a2} L^{a3} ... with the final exponent decremented."""
    runs = []
    for i, a in enumerate(L):
        e = a - 1 if i == 0 else a
        if i == len(L) - 1:
            e -= 1
        runs.append(("L" if i % 2 == 0 else "R") * e)
    return "".join(runs)


bad = 0
sample = triples[:8000]
for T in sample:
    t = triple_to_t(T)
    if sb_address(t) != sb_from_cf(cf_of(t)):
        bad += 1
check("Stern--Brocot address = run-length encoding of the CF", bad == 0,
      f"{len(sample)} fractions")

# --- parity residual: the mod-2 monodromy of the SB word -------------------
SBL = ((1, 0), (1, 1))
SBR = ((1, 1), (0, 1))


def sb_monodromy(word):
    M = ((1, 0), (0, 1))
    for ch in word:
        X = SBL if ch == "L" else SBR
        M = tuple(tuple(sum(M[i][k] * X[k][j] for k in range(2)) % 2
                        for j in range(2)) for i in range(2))
    return M


mono_euclid, mono_bothodd = set(), set()
allfr = []
for m in range(2, 90):
    for n in range(1, m):
        if gcd(m, n) == 1:
            allfr.append(Fraction(n, m))
for t in allfr:
    M = sb_monodromy(sb_address(t))
    if (t.numerator + t.denominator) % 2 == 1:
        mono_euclid.add(M)
    else:
        mono_bothodd.add(M)
say(f"  SL2(F_2) classes on the Euclid (opposite-parity) domain: {len(mono_euclid)}")
say(f"  SL2(F_2) classes on the both-odd domain:                {len(mono_bothodd)}")
check("parity of m+n is a function of the SB word's SL2(F_2) monodromy",
      mono_euclid.isdisjoint(mono_bothodd),
      f"{len(mono_euclid)} vs {len(mono_bothodd)} of the 6 elements of SL2(F_2)")


# ===========================================================================
# 4.  Group structure of S^1(Q):  Z/4  (+)  sum_{p = 1 mod 4} Z
# ===========================================================================
say("")
say("[4] Group structure of S^1(Q) via Z[i] unique factorisation")

# smallest prime factor sieve
spf = np.zeros(CMAX + 1, dtype=np.int64)
for i in range(2, int(math.isqrt(CMAX)) + 1):
    if spf[i] == 0:
        sl = spf[i * i:: i]
        sl[sl == 0] = i
idx = np.arange(CMAX + 1, dtype=np.int64)
spf = np.where(spf == 0, idx, spf)
spf[0] = spf[1] = 1


def factorize(x):
    f = {}
    while x > 1:
        p = int(spf[x])
        e = 0
        while x % p == 0:
            x //= p
            e += 1
        f[p] = e
    return f


# canonical Gaussian prime pi_p = u + i v with u > v > 0, u^2+v^2 = p
pi_of = {}
for u in range(2, m_top + 1):
    for v in range(1, u):
        s = u * u + v * v
        if s <= CMAX and gcd(u, v) == 1 and spf[s] == s:
            pi_of[s] = (u, v)
say(f"  canonical Gaussian primes pi_p stored for {len(pi_of)} primes p = 1 mod 4")

UNITS = [(1, 0), (0, 1), (-1, 0), (0, -1)]


def gauss_expvec(z):
    """factor a primitive z in Z[i]: returns (unit, {p: e}) with e in Z,
    e>0 meaning pi_p^e, e<0 meaning conj(pi_p)^{|e|}."""
    N = z[0] * z[0] + z[1] * z[1]
    ev = {}
    cur = z
    for p, e in factorize(N).items():
        pi = pi_of[p]
        k = 0
        while True:
            q = gdivexact(cur, pi)
            if q is None:
                break
            cur = q
            k += 1
        if k:
            ev[p] = k
        else:
            pib = gconj(pi)
            k2 = 0
            while True:
                q = gdivexact(cur, pib)
                if q is None:
                    break
                cur = q
                k2 += 1
            ev[p] = -k2
    return cur, ev


def point_of(z):
    """w = z / conj(z) as an exact pair of Fractions."""
    N = z[0] * z[0] + z[1] * z[1]
    w = gmul(z, z)
    return (Fraction(w[0], N), Fraction(w[1], N))


def gen_g(p):
    return point_of(pi_of[p])


def cmul(w, v):
    return (w[0] * v[0] - w[1] * v[1], w[0] * v[1] + w[1] * v[0])


def cpow(w, k):
    if k < 0:
        w = (w[0], -w[1])
        k = -k
    r = (Fraction(1), Fraction(0))
    for _ in range(k):
        r = cmul(r, w)
    return r


bad_unit = bad_rec = bad_ht = 0
prim_all_1mod4 = True
for T in triples:
    m, n = mn_of[T]
    z = (m, n)
    u, ev = gauss_expvec(z)
    if u not in UNITS:
        bad_unit += 1
    c = T[2]
    if any(p % 4 != 1 for p in ev):
        prim_all_1mod4 = False
    # height = product p^{|e_p|}
    h = 1
    for p, e in ev.items():
        h *= p ** abs(e)
    if h != c:
        bad_ht += 1
    # reconstruct the point
    w = (Fraction(1), Fraction(0))
    for p, e in ev.items():
        w = cmul(w, cpow(gen_g(p), e))
    # for a unit u, u/conj(u) = u^2 in {1,-1}
    uu = (Fraction(u[0] * u[0] - u[1] * u[1]), Fraction(2 * u[0] * u[1]))
    w = cmul(w, uu)
    if w != point_of(z):
        bad_rec += 1

check("every hypotenuse c factors into primes = 1 mod 4", prim_all_1mod4)
check("Z[i] factorisation of every primitive z has unit in {1,i,-1,-i}",
      bad_unit == 0)
check("height law  c(w) = prod_p p^{|e_p|}  exactly", bad_ht == 0, f"{NT} points")
check("reconstruction  w = (u/ubar) * prod_p g_p^{e_p}  exactly", bad_rec == 0)

# group law: exponent vectors add; torsion is exactly mu_4
rng = random.Random(SEED)
bad_add = bad_hprod = 0
for _ in range(4000):
    T1 = rng.choice(triples)
    T2 = rng.choice(triples)
    z1 = mn_of[T1]
    z2 = mn_of[T2]
    u1, e1 = gauss_expvec(z1)
    u2, e2 = gauss_expvec(z2)
    w = cmul(point_of(z1), point_of(z2))
    # exponent vector of the product, predicted
    e = dict(e1)
    for p, v in e2.items():
        e[p] = e.get(p, 0) + v
    e = {p: v for p, v in e.items() if v}
    wp = (Fraction(1), Fraction(0))
    for p, v in e.items():
        wp = cmul(wp, cpow(gen_g(p), v))
    s1 = (Fraction(u1[0] * u1[0] - u1[1] * u1[1]), Fraction(2 * u1[0] * u1[1]))
    s2 = (Fraction(u2[0] * u2[0] - u2[1] * u2[1]), Fraction(2 * u2[0] * u2[1]))
    wp = cmul(wp, cmul(s1, s2))
    if wp != w:
        bad_add += 1
    hp = 1
    for p, v in e.items():
        hp *= p ** abs(v)
    den = math.lcm(w[0].denominator, w[1].denominator)
    if hp != den:
        bad_hprod += 1
check("group law: exponent vectors add under multiplication (4000 random pairs)",
      bad_add == 0)
check("height of the product = prod p^{|e_p+e'_p|} (cancellation only within p)",
      bad_hprod == 0)

# torsion
bad_tors = 0
for T in triples[:3000]:
    w = point_of(mn_of[T])
    v = w
    for k in range(2, 13):
        v = cmul(v, w)
        if v == (Fraction(1), Fraction(0)):
            bad_tors += 1
            break
check("no primitive point of height>1 has finite order <= 12 (Niven)",
      bad_tors == 0, "torsion = mu_4 only")

# CONTROL: planted-false generator claim
p_false = 5
gf = (Fraction(4, 5), Fraction(3, 5))     # the *leg-swapped* point, not g_5
check_rejects("CONTROL-E  '(4/5,3/5) generates the p=5 component'",
              any(cpow(gf, k) == gen_g(5) for k in range(-6, 7)),
              "(4/5,3/5) = i * conj(g_5); not a power of g_5")


# ===========================================================================
# 5.  Diophantine geometry: chart versus ambient completion
# ===========================================================================
say("")
say("[5] Chart vs ambient: intrinsic Diophantine approximation on S^1")

ang = np.empty(NP, dtype=np.float64)
hts = np.empty(NP, dtype=np.int64)
for i, (a, b, c) in enumerate(pts):
    ang[i] = math.atan2(b, a) % (2 * math.pi)
    hts[i] = c
order = np.argsort(hts, kind="stable")
ang_by_h = ang[order]
hts_sorted = hts[order]

Hgrid = np.unique(np.round(np.logspace(1.0, math.log10(CMAX), 22)).astype(np.int64))
sorted_angles = {}
for H in Hgrid:
    k = int(np.searchsorted(hts_sorted, H, side="right"))
    sorted_angles[int(H)] = np.sort(ang_by_h[:k])

TWO_PI = 2 * math.pi


def cdist(x, y):
    d = abs(x - y) % TWO_PI
    return min(d, TWO_PI - d)


def dist_to_set(theta, arr):
    """circular distance from theta to a sorted array of angles in [0,2pi)."""
    n = len(arr)
    j = int(np.searchsorted(arr, theta))
    return min(cdist(theta, float(arr[j % n])),
               cdist(theta, float(arr[(j - 1) % n])))


rng2 = np.random.default_rng(SEED)
NTH = 3000
thetas = rng2.uniform(0, TWO_PI, NTH)
med = []
for H in Hgrid:
    arr = sorted_angles[int(H)]
    ds = np.array([dist_to_set(t, arr) for t in thetas])
    med.append(np.median(ds))
med = np.array(med)
fitmask = Hgrid >= 300           # drop small-H finite-size effects
lx, ly = np.log(Hgrid[fitmask].astype(float)), np.log(med[fitmask])
slope, intercept = np.polyfit(lx, ly, 1)
resid = ly - (slope * lx + intercept)
slope_all = np.polyfit(np.log(Hgrid.astype(float)), np.log(med), 1)[0]
say(f"  median over {NTH} random angles of dist to points of height <= H")
for H, d in zip(Hgrid, med):
    say(f"    H = {H:7d}   median delta = {d:.3e}   delta*H = {d*H:.4f}")
say(f"  fitted exponent (median, H>=300):  {slope:.4f}   (predicted -1)")
say(f"  fitted exponent (median, all H):   {slope_all:.4f}")
check("measured approximation exponent is -1 to within 0.06",
      abs(slope + 1.0) < 0.06, f"slope = {slope:.4f}")


def fit_quality(fixed_slope):
    b = np.mean(ly - fixed_slope * lx)
    return float(np.sqrt(np.mean((ly - (fixed_slope * lx + b)) ** 2)))


rms_free = float(np.sqrt(np.mean(resid ** 2)))
q1, qh, q2 = fit_quality(-1.0), fit_quality(-0.5), fit_quality(-2.0)
say(f"  rms residual: free {rms_free:.4f} | exponent -1 {q1:.4f} | "
    f"-1/2 {qh:.4f} | -2 {q2:.4f}")
check_rejects("CONTROL-F  'the approximation exponent is -1/2'", qh < 3 * q1,
              f"rms {qh:.3f} vs {q1:.3f}")
check_rejects("CONTROL-G  'the approximation exponent is -2'", q2 < 3 * q1,
              f"rms {q2:.3f} vs {q1:.3f}")

# --- badly approximable direction: golden angle --------------------------
phi = (math.sqrt(5) - 1) / 2
theta_bad = 2 * math.atan(phi)
theta_liouville = 2 * math.atan(sum(10.0 ** (-math.factorial(k)) for k in range(1, 8)))
say("")
say("  badly-approximable vs Liouville direction, product delta * H:")
prod_bad, prod_lio = [], []
for H in Hgrid:
    arr = sorted_angles[int(H)]
    db = dist_to_set(theta_bad, arr)
    dl = dist_to_set(theta_liouville, arr)
    prod_bad.append(db * H)
    prod_lio.append(dl * H)
    say(f"    H = {H:7d}   golden: delta*H = {db*H:8.4f}    "
        f"Liouville: delta*H = {dl*H:12.6f}")
check("golden direction: delta*H stays bounded (badly approximable)",
      max(prod_bad) < 8.0, f"max = {max(prod_bad):.3f}")
check("Liouville direction: delta*H dips far below the golden floor",
      min(prod_lio) < 0.05 * min(prod_bad) or min(prod_lio) < 1e-3,
      f"min = {min(prod_lio):.3e} vs golden min {min(prod_bad):.3f}")

# --- covering (uniform Dirichlet) exponent: the max gap -------------------
say("")
say("  uniform / covering exponent: sup over theta of the distance")
maxgap = []
for H in Hgrid:
    arr = sorted_angles[int(H)]
    g = np.diff(arr)
    g = np.append(g, arr[0] + TWO_PI - arr[-1])
    maxgap.append(g.max() / 2)
maxgap = np.array(maxgap)
sl_cov, ic_cov = np.polyfit(np.log(Hgrid.astype(float)), np.log(maxgap), 1)
mk = Hgrid >= 1000
sl_cov_tail = np.polyfit(np.log(Hgrid[mk].astype(float)), np.log(maxgap[mk]), 1)[0]
for H, d in zip(Hgrid, maxgap):
    say(f"    H = {H:7d}   sup_theta delta = {d:.4e}   delta*sqrt(H) = {d*math.sqrt(H):.4f}")
say(f"  fitted covering exponent (all H): {sl_cov:.4f}   (predicted -1/2)")
say(f"  fitted covering exponent (H>=1000): {sl_cov_tail:.4f}")
check("measured covering exponent is -1/2 to within 0.01 on H>=1000",
      abs(sl_cov_tail + 0.5) < 0.01, f"slope = {sl_cov_tail:.4f}")
const_meas = float(maxgap[-1] * math.sqrt(Hgrid[-1]))
say(f"  sharp constant:  sup_theta delta * sqrt(H) -> 1/sqrt(2) = {1/math.sqrt(2):.6f};"
    f"  measured at H={Hgrid[-1]}: {const_meas:.6f}")
check("covering constant matches the predicted 1/sqrt(2) to 3 decimals",
      abs(const_meas - 1 / math.sqrt(2)) < 5e-3,
      f"{const_meas:.6f} vs {1/math.sqrt(2):.6f}")
check_rejects("CONTROL-H  'the covering constant is 1 (i.e. sup delta ~ 1/sqrt(H))'",
              abs(const_meas - 1.0) < 5e-3, f"measured {const_meas:.6f}")
med_const = float(np.median(med[fitmask] * Hgrid[fitmask]))
say(f"  median constant: median_theta delta * H -> {med_const:.4f};"
    f"  perfectly equispaced points of the same count would give"
    f" pi^2/8 = {math.pi**2/8:.4f}")

# where is the worst-covered angle?  (for every H in the grid)
cusp_hits = 0
for H in Hgrid:
    arr = sorted_angles[int(H)]
    g = np.diff(arr)
    g = np.append(g, arr[0] + TWO_PI - arr[-1])
    imax = int(np.argmax(g))
    ends = [float(arr[imax]), float(arr[(imax + 1) % len(arr)])]
    if min(cdist(e, k * math.pi / 2) for e in ends for k in range(4)) < 1e-9:
        cusp_hits += 1
H = int(Hgrid[-1])
arr = sorted_angles[H]
g = np.diff(arr)
g = np.append(g, arr[0] + TWO_PI - arr[-1])
imax = int(np.argmax(g))
say(f"  worst gap at H = {H} is the arc starting at {arr[imax]:.6f} rad "
    f"(= {arr[imax]/math.pi:.4f} pi), i.e. anchored at a cusp")
check("for every H in the grid the widest gap has a cusp of mu_4 as an endpoint",
      cusp_hits == len(Hgrid), f"{cusp_hits}/{len(Hgrid)}")

# exact cusp-exclusion inequality:  c >= 1/(2 sin^2(delta/2))
worst_ratio = math.inf
eq_cases = 0
for (a, b, c) in pts:
    if c == 1:
        continue
    dl = min(cdist(math.atan2(b, a) % TWO_PI, k * math.pi / 2) for k in range(4))
    lhs = c * 2 * math.sin(dl / 2) ** 2
    worst_ratio = min(worst_ratio, lhs)
    if abs(lhs - 1.0) < 1e-9:
        eq_cases += 1
say(f"  exact cusp exclusion:  min over all {NP-4} non-cusp points of "
    f"2 c sin^2(delta/2) = {worst_ratio:.12f}   (predicted exactly 1)")
say(f"  equality cases (t = 1/q, q odd): {eq_cases}")
check("cusp-exclusion inequality  c >= 1/(2 sin^2(delta/2))  holds, sharp",
      worst_ratio > 1 - 1e-9 and eq_cases > 0,
      f"min ratio {worst_ratio:.12f}, {eq_cases} equality cases")
check_rejects("CONTROL-I  'the sharp cusp bound is c >= 1/sin^2(delta/2)'",
              all(c * math.sin(min(cdist(math.atan2(b, a) % TWO_PI,
                                         k * math.pi / 2) for k in range(4)) / 2) ** 2
                  >= 1 - 1e-9 for (a, b, c) in list(pts)[:5000] if c > 1),
              "factor 2 is not removable: t=1/q with q odd attains equality")


# ===========================================================================
# 6.  Rank-r subgroups: the chart<->ambient question
# ===========================================================================
say("")
say("[6] Rank-r subgroups of S^1(Q): approximation rate vs group rank")

PRIMES_R = [5, 13, 17]
alphas = [math.atan2(2 * pi_of[p][0] * pi_of[p][1],
                     pi_of[p][0] ** 2 - pi_of[p][1] ** 2) % TWO_PI
          for p in PRIMES_R]
logs = [math.log(p) for p in PRIMES_R]
say(f"  primes {PRIMES_R}, generator angles {[f'{a:.6f}' for a in alphas]}")

rng3 = np.random.default_rng(SEED + 1)
rank_results = {}
LOGH_RANGE = {1: (1.7, 3.6), 2: (1.5, 2.8), 3: (1.3, 2.2)}
for r in (1, 2, 3):
    lo, hi = LOGH_RANGE[r]
    Ls = [int(x) for x in np.unique(np.round(np.logspace(lo, hi, 9)).astype(int))]
    ths = rng3.uniform(0, TWO_PI, 200)
    meds = []
    for Lg in Ls:                    # Lg = log(H) budget
        pts_ang = []
        rng_n = [int(Lg / logs[j]) for j in range(r)]
        if r == 1:
            for n0 in range(-rng_n[0], rng_n[0] + 1):
                pts_ang.append(n0 * alphas[0])
        elif r == 2:
            for n0 in range(-rng_n[0], rng_n[0] + 1):
                rem = Lg - abs(n0) * logs[0]
                if rem < 0:
                    continue
                k1 = int(rem / logs[1])
                for n1 in range(-k1, k1 + 1):
                    pts_ang.append(n0 * alphas[0] + n1 * alphas[1])
        else:
            for n0 in range(-rng_n[0], rng_n[0] + 1):
                rem0 = Lg - abs(n0) * logs[0]
                if rem0 < 0:
                    continue
                k1 = int(rem0 / logs[1])
                for n1 in range(-k1, k1 + 1):
                    rem1 = rem0 - abs(n1) * logs[1]
                    k2 = int(rem1 / logs[2])
                    for n2 in range(-k2, k2 + 1):
                        pts_ang.append(n0 * alphas[0] + n1 * alphas[1] + n2 * alphas[2])
        A = np.sort(np.mod(np.array(pts_ang), TWO_PI))
        # include the mu_4 rotations
        A = np.sort(np.mod(np.concatenate([A + k * math.pi / 2 for k in range(4)]), TWO_PI))
        ds = np.array([dist_to_set(t, A) for t in ths])
        meds.append(np.median(ds))
    meds = np.array(meds)
    s, _ = np.polyfit(np.log(Ls), np.log(meds), 1)
    rank_results[r] = (Ls, meds.tolist(), float(s))
    say(f"  rank {r}: fitted exponent of delta vs log(H) = {s:.3f}   (predicted -{r})")

check("rank-1 subgroup gives rate ~ (log H)^{-1}",
      abs(rank_results[1][2] + 1) < 0.25, f"{rank_results[1][2]:.3f}")
check("rank-2 subgroup gives rate ~ (log H)^{-2}",
      abs(rank_results[2][2] + 2) < 0.35, f"{rank_results[2][2]:.3f}")
check("rank-3 subgroup gives rate ~ (log H)^{-3}",
      abs(rank_results[3][2] + 3) < 0.5, f"{rank_results[3][2]:.3f}")
say("  => full rank gives delta ~ H^{-1}; finite rank r gives only "
    "delta ~ (log H)^{-r}.")


# ===========================================================================
# 7.  Ledger
# ===========================================================================
say("")
say("=" * 74)
if FAILURES:
    say(f"FAILURES ({len(FAILURES)}): {FAILURES}")
else:
    say("ALL CHECKS PASSED; ALL PLANTED-FALSE CONTROLS REJECTED.")
say("=" * 74)

os.makedirs(DATA, exist_ok=True)
summary = {
    "cmax": CMAX,
    "n_primitive_triples": NT,
    "n_rational_points": NP,
    "fiber_identity": f"{NP} = 8*{NT} + 4",
    "lehmer_ratio": NT / (CMAX / (2 * math.pi)),
    "d4_orbit_census": {str(k): v for k, v in orbit_sizes.items()},
    "approx_exponent_measured": float(slope),
    "approx_exponent_predicted": -1.0,
    "approx_rms_free": rms_free,
    "approx_rms_at_-1": q1,
    "approx_rms_at_-0.5": qh,
    "approx_rms_at_-2": q2,
    "covering_exponent_measured_allH": float(sl_cov),
    "covering_exponent_measured_tail": float(sl_cov_tail),
    "covering_exponent_predicted": -0.5,
    "covering_constant_measured": const_meas,
    "covering_constant_predicted": 1 / math.sqrt(2),
    "median_constant_measured": med_const,
    "golden_deltaH_max": float(max(prod_bad)),
    "liouville_deltaH_min": float(min(prod_lio)),
    "rank_rates": {str(r): rank_results[r][2] for r in rank_results},
    "failures": FAILURES,
}
with open(os.path.join(DATA, "exp61_atlas.json"), "w") as f:
    json.dump(summary, f, indent=2)
with open(os.path.join(DATA, "exp61_out.txt"), "w") as f:
    f.write("\n".join(LOG) + "\n")

np.savez(os.path.join(DATA, "exp61_diophantine.npz"),
         Hgrid=Hgrid, med=med, maxgap=maxgap,
         prod_bad=np.array(prod_bad), prod_lio=np.array(prod_lio),
         rank1=np.array(rank_results[1][1]), rank2=np.array(rank_results[2][1]),
         rank3=np.array(rank_results[3][1]),
         rankL=np.array(rank_results[1][0]))
say(f"wrote data/exp61_out.txt, data/exp61_atlas.json, data/exp61_diophantine.npz")


# ===========================================================================
# 8.  Figures
# ===========================================================================
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# categorical slots 1-3 (validated all-pairs, light mode) + violet for a 4th
C1, C2, C3, C4 = "#2a78d6", "#eb6834", "#1baf7a", "#4a3aa7"
INK, INK2, GRID = "#0b0b0b", "#52514e", "#d9d8d2"
plt.rcParams.update({
    "figure.facecolor": "#fcfcfb", "axes.facecolor": "#fcfcfb",
    "axes.edgecolor": GRID, "axes.labelcolor": INK2, "text.color": INK,
    "xtick.color": INK2, "ytick.color": INK2, "font.size": 9,
    "axes.grid": True, "grid.color": GRID, "grid.linewidth": 0.6,
    "axes.spines.top": False, "axes.spines.right": False,
})
os.makedirs(FIGS, exist_ok=True)
Hf = Hgrid.astype(float)

# --- figure 1: the approximation exponent, with wrong-exponent controls ----
fig, ax = plt.subplots(figsize=(6.4, 4.4))
ax.loglog(Hf, med, "o", ms=5, color=C1, zorder=4,
          label="measured median over 3000 random angles")
b1 = np.mean(np.log(med) + 1.0 * np.log(Hf))
ax.loglog(Hf, np.exp(b1) / Hf, "-", lw=2, color=C1, zorder=3)
bh_ = np.mean(np.log(med) + 0.5 * np.log(Hf))
ax.loglog(Hf, np.exp(bh_) * Hf ** -0.5, "--", lw=2, color=C2, zorder=2)
b2 = np.mean(np.log(med) + 2.0 * np.log(Hf))
ax.loglog(Hf, np.exp(b2) * Hf ** -2.0, "--", lw=2, color=C3, zorder=2)
ax.annotate(r"proved slope $-1$", (Hf[-7], np.exp(b1) / Hf[-7]),
            textcoords="offset points", xytext=(-6, 14), color=C1, fontsize=9,
            ha="right")
ax.annotate(r"control $-1/2$  REJECTED", (Hf[3], np.exp(bh_) * Hf[3] ** -0.5),
            textcoords="offset points", xytext=(4, 8), color=C2, fontsize=9)
ax.annotate(r"control $-2$  REJECTED", (Hf[3], np.exp(b2) * Hf[3] ** -2.0),
            textcoords="offset points", xytext=(4, -14), color=C3, fontsize=9)
ax.set_xlabel("height bound $H$ (hypotenuse $c$)")
ax.set_ylabel(r"median$_\theta$  dist$(\theta,\ S^1(\mathbb{Q})_{\leq H})$")
ax.set_title(f"exp61  intrinsic approximation exponent on $S^1$\n"
             f"fitted {slope:.4f} (rms {q1:.3f}) vs controls "
             f"$-1/2$ (rms {qh:.2f}), $-2$ (rms {q2:.2f})",
             color=INK, fontsize=10)
ax.legend(frameon=False, loc="lower left", fontsize=8)
fig.tight_layout()
fig.savefig(os.path.join(FIGS, "exp61_approx_exponent.png"), dpi=170)
plt.close(fig)

# --- figure 2: the two normalized constants (small multiples) --------------
fig, axes = plt.subplots(1, 2, figsize=(9.2, 3.9))
axes[0].semilogx(Hf, med * Hf, "o-", ms=4, lw=1.6, color=C1)
axes[0].axhline(math.pi ** 2 / 8, color=INK2, lw=1.4, ls=":")
axes[0].annotate(r"$\pi^2/8$  (equispaced)", (Hf[2], math.pi ** 2 / 8),
                 textcoords="offset points", xytext=(4, 6), color=INK2, fontsize=8)
axes[0].set_ylim(0.9, 1.6)
axes[0].set_xlabel("$H$")
axes[0].set_ylabel(r"median$_\theta\ \delta \cdot H$")
axes[0].set_title("typical direction: exponent 1", color=INK, fontsize=10)

axes[1].semilogx(Hf, maxgap * np.sqrt(Hf), "o-", ms=4, lw=1.6, color=C2)
axes[1].axhline(1 / math.sqrt(2), color=INK2, lw=1.4, ls=":")
axes[1].annotate(r"$1/\sqrt{2}$  (proved cusp constant)",
                 (Hf[2], 1 / math.sqrt(2)), textcoords="offset points",
                 xytext=(4, 8), color=INK2, fontsize=8)
axes[1].set_ylim(0.6, 1.1)
axes[1].set_xlabel("$H$")
axes[1].set_ylabel(r"$\sup_\theta\ \delta \cdot \sqrt{H}$")
axes[1].set_title("worst direction: exponent 1/2", color=INK, fontsize=10)
fig.suptitle("exp61  two different exponents on the same set: "
             "typical vs uniform approximation", fontsize=10, color=INK)
fig.tight_layout()
fig.savefig(os.path.join(FIGS, "exp61_covering.png"), dpi=170)
plt.close(fig)

# --- figure 3: rank-r subgroup rates --------------------------------------
fig, ax = plt.subplots(figsize=(6.4, 4.4))
for r, col in ((1, C1), (2, C2), (3, C3)):
    Ls, ms_, s = rank_results[r]
    ax.loglog(Ls, ms_, "o-", ms=5, lw=1.7, color=col,
              label=f"rank {r}: fitted {s:.2f}, predicted $-{r}$")
    ax.annotate(f"$r={r}$", (Ls[-1], ms_[-1]), textcoords="offset points",
                xytext=(6, -2), color=col, fontsize=9)
ax.set_xlabel(r"$\log H$  (height budget of the subgroup)")
ax.set_ylabel(r"median$_\theta$ dist to $\langle g_{p_1},\dots,g_{p_r}\rangle_{\leq H}$")
ax.set_title("exp61  rank collapses the rate: full rank gives $H^{-1}$,\n"
             r"rank $r$ gives only $(\log H)^{-r}$   ($p = 5,13,17$)",
             color=INK, fontsize=10)
ax.legend(frameon=False, loc="upper right", fontsize=8)
fig.tight_layout()
fig.savefig(os.path.join(FIGS, "exp61_rank_rate.png"), dpi=170)
plt.close(fig)

# --- figure 4: the chart in the ambient circle -----------------------------
HSHOW = 400
sel = [(a, b, c) for (a, b, c) in pts if c <= HSHOW]
fig, (axL, axR) = plt.subplots(1, 2, figsize=(10.4, 5.2))

th = np.linspace(0, TWO_PI, 2000)
axL.plot(np.cos(th), np.sin(th), color=GRID, lw=1.4, zorder=1)
cs = np.array([c for (_, _, c) in sel], dtype=float)
xs = np.array([a / c for (a, _, c) in sel])
ys = np.array([b / c for (_, b, c) in sel])
o = np.argsort(cs)[::-1]                     # tall (light) first, low on top
sc = axL.scatter(xs[o], ys[o], c=np.log(cs[o]), s=90 / np.log(cs[o] + 2) ** 1.3,
                 cmap="Blues", vmin=-1.2, vmax=math.log(HSHOW),
                 zorder=3, linewidths=0)
axL.scatter([1, -1, 0, 0], [0, 0, 1, -1], s=90, facecolors="none",
            edgecolors=C2, linewidths=2.0, zorder=4)
for (x, y, lab) in ((1, 0, "$1$"), (0, 1, "$i$"), (-1, 0, "$-1$"), (0, -1, "$-i$")):
    axL.annotate(lab, (x, y), textcoords="offset points",
                 xytext=(13 * x + (-3 if x == 0 else 0), 13 * y - 4),
                 color=C2, fontsize=11, ha="center")
cb = fig.colorbar(sc, ax=axL, fraction=0.045, pad=0.03)
cb.set_label(r"$\log c$  (height); dark = low", color=INK2, fontsize=8)
cb.outline.set_edgecolor(GRID)
axL.set_aspect("equal")
axL.axis("off")
axL.set_title(f"$S^1(\\mathbb{{Q}})$ of height $\\leq {HSHOW}$: {len(sel)} points\n"
              r"visibly thinning at the four cusps $\mu_4$",
              color=INK, fontsize=10)

# right: the reachability envelope at the cusp theta = 0
cut = [(a, b, c) for (a, b, c) in pts if c <= 20000]
angs = np.array([math.atan2(b, a) for (a, b, c) in cut])
hh = np.array([c for (_, _, c) in cut], dtype=float)
m = np.abs(angs) < 0.32
axR.semilogy(angs[m], hh[m], "o", ms=2.6, color=C1, alpha=0.55, mew=0,
             linestyle="none", label="rational points (angle, height)")
dd = np.linspace(0.008, 0.32, 400)
env = 1.0 / (2 * np.sin(dd / 2) ** 2)
axR.semilogy(dd, env, "-", lw=2, color=C2)
axR.semilogy(-dd, env, "-", lw=2, color=C2)
axR.annotate(r"sharp bound  $c \geq 1/(2\sin^2(\delta/2))$",
             (0.145, 1 / (2 * math.sin(0.145 / 2) ** 2)),
             textcoords="offset points", xytext=(6, 16), color=C2, fontsize=9)
axR.set_xlim(-0.32, 0.32)
axR.set_ylim(1, 20000)
axR.set_xlabel(r"angle $\delta$ from the cusp $1 \in \mu_4$")
axR.set_ylabel("height $c$")
axR.set_title("no rational point of height $c$ lies within\n"
              r"$\delta < \sqrt{2/c}$ of a cusp: the exponent-$1/2$ obstruction",
              color=INK, fontsize=10)
fig.suptitle("exp61  the omitted locus is not uniform: the chart is sparsest "
             "exactly on its own $D_4$-fixed orbit", fontsize=10, color=INK)
fig.tight_layout()
fig.savefig(os.path.join(FIGS, "exp61_circle_chart.png"), dpi=170)
plt.close(fig)

say("wrote figures/exp61_approx_exponent.png, exp61_covering.png, "
    "exp61_rank_rate.png, exp61_circle_chart.png")
with open(os.path.join(DATA, "exp61_out.txt"), "w") as f:
    f.write("\n".join(LOG) + "\n")
sys.exit(1 if FAILURES else 0)
