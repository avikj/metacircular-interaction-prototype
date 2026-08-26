"""exp41: the Selberg two-model swap, measured.

The endpoint measures nu_pm(n) = 1 +/- lambda(n) on [1,X] are compared
exactly.  A "common shadow" is a declared channel on the two-element endpoint
domain that identifies them; ordinary linear tests need not do so.

Measured here (X = 2*10^6 default):
  (A) axiom-value agreement: for moduli q <= Q, residues a, the AP counts
      sum_{n<=X, n=a(q)} w_pm(n) agree up to the lambda-discrepancy
      D(q,a) = |sum_{n<=X, n=a(q)} lambda(n)|, reported in units of
      sqrt(X/q) (square-root cancellation null).  This is the finite-level
      a falsifier for any claim of exact AP agreement.  No asymptotic
      square-root bound is inferred from this finite measurement.
  (B) target separation: primes get total weight 0 under w_+ and 2*pi(X)
      under w_-.
  (C) pair charge: a separate endpoint system for the twin problem on
      n=1,...,X-2, with pair flip
      c_2(n) = lambda(n)lambda(n+2): weights 1 +/- c_2 agree on even
      endpoint observables by definition and separate the twin target as
      2*pi_2(X) versus 0.  This pair-charge flip is not induced by the global
      sign change lambda -> -lambda, which fixes c_2.
Output: data/exp41_out.txt
"""
import sys, os
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pairfield import sieve_primes

X = int(sys.argv[1]) if len(sys.argv) > 1 else 2_000_000

# honest lambda via factor-count sieve
def liouville2(X):
    omega_par = np.zeros(X + 1, dtype=np.int8)  # parity of Omega(n)
    rem = np.arange(X + 1, dtype=np.int64)
    for p in range(2, X + 1):
        if rem[p] == p:  # prime (never divided out by a smaller prime)
            idx = np.arange(p, X + 1, p)
            while len(idx):
                omega_par[idx] ^= 1
                rem[idx] //= p
                idx = idx[rem[idx] % p == 0]
    lam = np.where(omega_par == 0, 1, -1).astype(np.int8)
    lam[0] = 0
    return lam

lam = liouville2(X)
isp = sieve_primes(X).astype(bool)
out = []
out.append(f"# exp41: Selberg two-model swap, X={X}")

# sanity: sum lambda should be o(X) and lambda(p) = -1
assert all(lam[p] == -1 for p in [2, 3, 5, 7, 997]) and lam[4] == 1 and lam[6] == 1
out.append(f"sum lambda = {int(lam[1:].sum())}  (|.|/sqrt(X) = {abs(lam[1:].sum())/X**0.5:.3f})")
out.append(f"exact masses: mass(nu+) = {int((1 + lam[1:]).sum())}, "
           f"mass(nu-) = {int((1 - lam[1:]).sum())}")

# (A) axiom agreement in APs
rng = np.random.default_rng(41)
rows = []
for q in [3, 7, 30, 101, 997, 9973, 99991]:
    if q >= X // 10: continue
    worst = 0.0
    for a in range(q):
        d = abs(int(lam[a::q][1:].sum() if a == 0 else lam[a::q].sum()))
        worst = max(worst, d / (X / q) ** 0.5)
    rows.append((q, worst))
out.append("(A) AP discrepancy (nonzero means AP counts are not an exact common shadow):")
for q, w in rows:
    out.append(f"    q={q:6d}  {w:8.3f}")

# (B) target separation
wp = 1 + lam[1:]; wm = 1 - lam[1:]
pi_X = int(isp[1:].sum())
out.append(f"(B) prime target: sum w+ over primes = {int(wp[isp[1:]].sum())}, "
           f"sum w- over primes = {int(wm[isp[1:]].sum())} = 2*pi(X) = {2*pi_X}")

# (C) pair charge for twins
c2 = (lam[1:X-1] * lam[3:X+1]).astype(np.int64)   # c2(n) = lam(n)lam(n+2), n=1..X-2
twin = isp[1:X-1] & isp[3:X+1]
pi2 = int(twin.sum())
wp2 = 1 + c2; wm2 = 1 - c2
out.append(f"(C) twin target: sum(1+c2) over twin n = {int(wp2[twin].sum())} = 2*pi2 = {2*pi2}, "
           f"sum(1-c2) over twin n = {int(wm2[twin].sum())}")
out.append(f"    mean c2 over all n = {c2.mean():+.6f}  (Chowla-2 scale: known o(1) only log-averaged)")

# Floating replay of the exact unnormalized linear-integral identity.  This is
# not an equality of normalized expectations and does not make g invariant
# under the endpoint swap.
g = rng.random(X)
out.append(f"integral identity residual: nu+(g) - nu-(g) - 2<lambda,g> = {float((wp*g).sum() - (wm*g).sum() - 2*(lam[1:]*g).sum()):.1e} "
           f"(identity: difference = 2<lam,g>; charged part carries ALL separation)")

txt = "\n".join(out)
print(txt)
open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "data", "exp41_out.txt"), "w").write(txt + "\n")
