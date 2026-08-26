"""exp38: hostile cross-review of notes/PROJECTION_LEAKAGE.md (Codex, msg 0033)
and the mod-6 Liouville witnesses of notes/CUBICAL_QUOTIENT_AUDIT.md.

Independent implementation (Claude Fable). Nothing here reuses Codex code:
operators are built as literal matrices from the definitions in the note,
kernels are computed from the definition of correlation (not from the CRT
product formula), and the CRT product formula is then tested AGAINST that
independent computation.

Conventions copied from the note (normalized counting measure):
  <f,g> = E_x f(x) conj(g(x));   (a*b)(x) = E_y a(x-y)b(y);
  (a star b)(h) = E_x conj(a(x)) b(x+h);   P_p f = kappa * f,
  kappa(r) = sum_chi p(chi) chi(r);   M_w f = w f;  [M,P] = MP - PM.
HS norm: ||T||_HS^2 = Tr(T^*T) = Frobenius sum of the ordinary matrix
(independent of the normalization of the inner product, since adjoint is
unchanged by scaling).

Checks:
  A. General HS identities on Z/N: random complex symbol p, random complex
     window w -> physical (displacement) formula and spectral formula.
  B. Indicator-window symmetric-difference formula, random A.
  C. Z/4 worked example from the note, exact rationals.
  D. W=6 arithmetic example, exact rationals (S_6, kappa_6, HS^2 = 1/3).
  E. W=30: S_W from the correlation definition vs the CRT product formula;
     centered multiplier positivity (symbol >= 0), self-adjointness,
     NON-idempotency; HS identity for interval and random A (float, and
     exact Fractions for one random A).
  F. Mod-6 Liouville witnesses: c(1) != c(7) with q6 equal; c(1) = c(25),
     q6 equal, 1 != 25; plus a fiber census showing every coprime residue
     class mod 6 contains both charges (descent fails everywhere, not just
     at the chosen witnesses).
"""

import numpy as np
from fractions import Fraction
from math import gcd
from itertools import product

rng = np.random.default_rng(20260811)
PASS = []


def check(name, ok, detail=""):
    PASS.append(ok)
    print(f"[{'PASS' if ok else 'FAIL'}] {name} {detail}")


# ---------- generic builders (independent of the note's proofs) ----------

def conv_matrix(kappa, N):
    """Matrix of f -> kappa * f, (Pf)(x) = (1/N) sum_y kappa(x-y) f(y)."""
    P = np.empty((N, N), dtype=complex)
    for x in range(N):
        for y in range(N):
            P[x, y] = kappa[(x - y) % N] / N
    return P


def kappa_from_symbol(p, N):
    """kappa(r) = sum_j p(chi_j) chi_j(r), chi_j(r) = e^{2 pi i j r / N}."""
    r = np.arange(N)
    return np.array([sum(p[j] * np.exp(2j * np.pi * j * rr / N)
                         for j in range(N)) for rr in r])


def hs2(T):
    return float(np.sum(np.abs(T) ** 2))


# ---------- A: general HS identities, random symbol + window ----------
for N in (12, 30):
    p = rng.normal(size=N) + 1j * rng.normal(size=N)
    w = rng.normal(size=N) + 1j * rng.normal(size=N)
    kappa = kappa_from_symbol(p, N)
    P = conv_matrix(kappa, N)
    M = np.diag(w)
    C = M @ P - P @ M
    lhs = hs2(C)
    # physical / displacement formula
    rhs_phys = sum(abs(kappa[r]) ** 2
                   * sum(abs(w[x] - w[(x - r) % N]) ** 2 for x in range(N))
                   for r in range(N)) / N ** 2
    # spectral formula: sum_{j,k} |p(k)-p(j)|^2 |w_hat((j-k) mod N)|^2
    what = np.array([np.mean([w[x] * np.exp(-2j * np.pi * j * x / N)
                              for x in range(N)]) for j in range(N)])
    rhs_spec = sum(abs(p[k] - p[j]) ** 2 * abs(what[(j - k) % N]) ** 2
                   for j in range(N) for k in range(N))
    check(f"A: physical HS identity, N={N}", abs(lhs - rhs_phys) < 1e-9 * (1 + lhs),
          f"lhs={lhs:.12f} rhs={rhs_phys:.12f}")
    check(f"A: spectral HS identity, N={N}", abs(lhs - rhs_spec) < 1e-9 * (1 + lhs),
          f"rhs={rhs_spec:.12f}")

# ---------- B: indicator window, random A ----------
for N in (12, 30):
    p = rng.normal(size=N)
    kappa = kappa_from_symbol(p, N)
    P = conv_matrix(kappa, N)
    A = set(int(a) for a in rng.choice(N, size=N // 3, replace=False))
    w = np.array([1.0 if x in A else 0.0 for x in range(N)])
    C = np.diag(w) @ P - P @ np.diag(w)
    symdiff = [len(A.symmetric_difference({(a + r) % N for a in A}))
               for r in range(N)]
    rhs = sum(abs(kappa[r]) ** 2 * symdiff[r] for r in range(N)) / N ** 2
    check(f"B: |A sym-diff (A+r)| formula, N={N}, random A",
          abs(hs2(C) - rhs) < 1e-9 * (1 + rhs))

# ---------- C: Z/4 worked example, exact ----------
N = 4
kappa4 = [Fraction(2), Fraction(0), Fraction(2), Fraction(0)]
P4 = [[kappa4[(x - y) % 4] / 4 for y in range(4)] for x in range(4)]
A4 = {0, 1}
w4 = [Fraction(1 if x in A4 else 0) for x in range(4)]
C4 = [[(w4[x] - w4[y]) * P4[x][y] for y in range(4)] for x in range(4)]
expected = {(0, 2): Fraction(1, 2), (1, 3): Fraction(1, 2),
            (2, 0): Fraction(-1, 2), (3, 1): Fraction(-1, 2)}
entries_ok = all(C4[x][y] == expected.get((x, y), Fraction(0))
                 for x in range(4) for y in range(4))
hs_c4 = sum(C4[x][y] ** 2 for x in range(4) for y in range(4))
check("C: Z/4 nonzero entries +-1/2 exactly as stated", entries_ok)
check("C: Z/4 HS^2 = 1 exactly", hs_c4 == 1, f"got {hs_c4}")
sd2 = len(A4.symmetric_difference({(a + 2) % 4 for a in A4}))
check("C: Z/4 displacement formula = 1", Fraction(sd2 * 4, 16) == 1)

# ---------- D: W=6 exact arithmetic example ----------
W = 6
eW = [Fraction(1 if gcd(x, W) == 1 else 0) for x in range(W)]
alpha = sum(eW) / W
S6 = [sum(eW[x] * eW[(x + h) % W] for x in range(W)) / W / alpha ** 2
      for h in range(W)]
check("D: S_6 = (3,0,3/2,0,3/2,0)",
      S6 == [Fraction(3), 0, Fraction(3, 2), 0, Fraction(3, 2), 0], f"{S6}")
kappa6 = [s - 1 for s in S6]
A6 = {0, 1, 2}
sd = [len(A6.symmetric_difference({(a + h) % W for a in A6})) for h in range(W)]
check("D: symmetric differences (0,2,4,6,4,2)", sd == [0, 2, 4, 6, 4, 2])
rhs6 = sum(kappa6[h] ** 2 * sd[h] for h in range(W)) / W ** 2
check("D: RHS = 1/3 exactly", rhs6 == Fraction(1, 3), f"got {rhs6}")
P6 = [[kappa6[(x - y) % W] / W for y in range(W)] for x in range(W)]
w6 = [Fraction(1 if x in A6 else 0) for x in range(W)]
C6 = [[(w6[x] - w6[y]) * P6[x][y] for y in range(W)] for x in range(W)]
hs6 = sum(c * c for row in C6 for c in row)
# also direct matrix commutator, not the kernel shortcut
M6 = [[Fraction(1 if x == y and x in A6 else 0) for y in range(W)] for x in range(W)]
def matmul(A, B):
    return [[sum(A[i][k] * B[k][j] for k in range(len(B))) for j in range(len(B[0]))]
            for i in range(len(A))]
MP = matmul(M6, P6); PM = matmul(P6, M6)
hs6_direct = sum((MP[i][j] - PM[i][j]) ** 2 for i in range(W) for j in range(W))
check("D: matrix HS^2 = 1/3 exactly (kernel and direct commutator)",
      hs6 == Fraction(1, 3) and hs6_direct == Fraction(1, 3),
      f"kernel={hs6} direct={hs6_direct}")

# ---------- E: W=30 sieve multiplier ----------
W = 30
eW = np.array([1.0 if gcd(x, W) == 1 else 0.0 for x in range(W)])
alpha = eW.mean()
S = np.array([np.mean(eW * np.roll(eW, -h)) for h in range(W)]) / alpha ** 2
# CRT product formula, independently
def crt_S(h, W):
    val = Fraction(1)
    for pp in (2, 3, 5):
        if W % pp == 0:
            val *= Fraction(pp, pp - 1) if h % pp == 0 \
                else Fraction(pp * (pp - 2), (pp - 1) ** 2)
    return val
S_crt = np.array([float(crt_S(h, W)) for h in range(W)])
check("E: correlation S_W matches CRT product formula, W=30",
      np.allclose(S, S_crt, atol=1e-12))
kappa = S - 1.0
P = conv_matrix(kappa, W).real
# symbol = eigenvalues of the circulant = DFT of kappa/... : p(chi_j) = kappa_hat(j)
symbol = np.array([np.mean([kappa[r] * np.exp(-2j * np.pi * j * r / W)
                            for r in range(W)]) * W / W for j in range(W)])
# note: with kappa(r) = sum_j p_j chi_j(r), p_j = (1/W) sum_r kappa(r) chi_j(r)^{-1}
check("E: symbol real and >= 0 (positivity)",
      np.all(np.abs(symbol.imag) < 1e-12) and np.all(symbol.real > -1e-12),
      f"min={symbol.real.min():.3e}")
check("E: self-adjoint (P = P^T real)", np.allclose(P, P.T))
check("E: NOT a projection: some symbol value outside {0,1} and P^2 != P",
      np.linalg.norm(P @ P - P) > 1e-6
      and np.any(np.minimum(np.abs(symbol.real), np.abs(symbol.real - 1)) > 1e-6),
      f"||P^2-P||_F={np.linalg.norm(P @ P - P):.4f}; "
      f"symbol values not in {{0,1}}: e.g. {sorted(set(np.round(symbol.real, 6)))[:6]}")
for name, A in (("interval [0,10)", set(range(10))),
                ("random 12-set", set(int(a) for a in rng.choice(W, 12, replace=False))),
                ("units mod 30", {x for x in range(W) if gcd(x, W) == 1}),
                ("evens", set(range(0, W, 2)))):
    w = np.array([1.0 if x in A else 0.0 for x in range(W)])
    C = np.diag(w) @ P - P @ np.diag(w)
    rhs = sum(abs(S[h] - 1) ** 2
              * len(A.symmetric_difference({(a + h) % W for a in A}))
              for h in range(W)) / W ** 2
    check(f"E: HS identity W=30, A = {name}",
          abs(hs2(C) - rhs) < 1e-10 * (1 + rhs),
          f"lhs={hs2(C):.10f} rhs={rhs:.10f}")
# exact-rational replay of one case
Wf = 30
eWf = [Fraction(1 if gcd(x, Wf) == 1 else 0) for x in range(Wf)]
alf = sum(eWf) / Wf
Sf = [sum(eWf[x] * eWf[(x + h) % Wf] for x in range(Wf)) / Wf / alf ** 2
      for h in range(Wf)]
kf = [s - 1 for s in Sf]
Af = {0, 3, 4, 7, 11, 12, 18, 19, 22, 25, 26, 29}
Pf = [[kf[(x - y) % Wf] / Wf for y in range(Wf)] for x in range(Wf)]
wf = [Fraction(1 if x in Af else 0) for x in range(Wf)]
Cf = [[(wf[x] - wf[y]) * Pf[x][y] for y in range(Wf)] for x in range(Wf)]
lhs_f = sum(c * c for row in Cf for c in row)
rhs_f = sum((Sf[h] - 1) ** 2
            * len(Af.symmetric_difference({(a + h) % Wf for a in Af}))
            for h in range(Wf)) / Wf ** 2
check("E: exact-rational HS identity at W=30", lhs_f == rhs_f,
      f"both = {lhs_f}")

# ---------- F: mod-6 Liouville witnesses ----------
def Omega(n):
    c, d = 0, 2
    while d * d <= n:
        while n % d == 0:
            n //= d; c += 1
        d += 1
    if n > 1:
        c += 1
    return c

c = lambda n: Omega(n) % 2
check("F: q6(1)=q6(7)=1 but c(1)=0 != c(7)=1  (charge does not descend)",
      1 % 6 == 7 % 6 == 1 and c(1) == 0 and c(7) == 1)
check("F: q6(1)=q6(25)=1, c(1)=c(25)=0, 1 != 25  ((q6,c) not injective)",
      25 % 6 == 1 and c(25) == 0)
# census: both charges occur in every coprime fiber quickly
census = {}
for n in range(1, 200):
    census.setdefault((n % 6, c(n)), []).append(n)
both = all((r, b) in census for r in (1, 5) for b in (0, 1))
check("F: every coprime residue mod 6 carries both charges below 200", both,
      f"e.g. (1,0):{census[(1,0)][:3]} (1,1):{census[(1,1)][:3]} "
      f"(5,0):{census[(5,0)][:3]} (5,1):{census[(5,1)][:3]}")

print(f"\n{sum(PASS)}/{len(PASS)} checks pass")
