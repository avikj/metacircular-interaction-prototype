# Hostile cross-review of notes/LENS_REGULARITY.md (msg 0026), independent replication.
# Differences from code/exp36_cutnorm.py (deliberate, per protocol: different method):
#   - Lambda via smallest-prime-factor sieve + prime-power test (exp36: composite sieve + power loop)
#   - c_q(n) via Hoelder's identity c_q(n) = mu(q/(q,n)) phi(q)/phi(q/(q,n))
#     (exp36: divisor-sum residue tables)
#   - mu/phi/sigma from sympy (exp36: hand-rolled trial division)
# Checks:
#   (A) replicate the X=10^6 (and 10^4, 10^5) rows of exp36's table: D(X), D/sqrt X, meas-cut/X, D_Q - D_1
#   (B) Lemma 1.1 numerically: max_x |sum_{n<=x, n=a(q)} Lambda^sharp_Q(n) - 1_{(a,q)=1} x/phi(q)|
#       for Q=30, several q (incl. non-squarefree q=4,12 and non-coprime residues), vs C_Q
import numpy as np
from math import gcd, log, sqrt
from sympy import mobius, totient, divisor_sigma

N = 10**6

# ---- smallest prime factor sieve ----
spf = np.zeros(N + 1, dtype=np.int32)
for p in range(2, int(N**0.5) + 1):
    if spf[p] == 0:
        seg = spf[p * p:: p]
        seg[seg == 0] = p
spf[spf == 0] = 0  # primes and 0,1 still 0
# Lambda
lam = np.zeros(N + 1)
logs = {}
for n in range(2, N + 1):
    p = spf[n]
    if p == 0:
        # n is prime
        lam[n] = log(n)
        continue
    m = n
    while m % p == 0:
        m //= p
    if m == 1:
        lam[n] = logs.setdefault(p, log(p))

# ---- Lambda^sharp_Q via Hoelder ----
def lam_sharp_vec(Q):
    n = np.arange(N + 1)
    out = np.ones(N + 1)
    for q in range(2, Q + 1):
        mq = int(mobius(q))
        if mq == 0:
            continue
        phq = int(totient(q))
        tab = np.empty(q)
        for r in range(q):
            g = gcd(q, r)
            qn = q // g
            tab[r] = int(mobius(qn)) * phq / int(totient(qn))
        out += (mq / phq) * tab[n % q]
    return out

results = {}
for Q in (1, 30):
    sharp = lam_sharp_vec(Q)
    f = lam - sharp
    f[0] = 0.0
    path = np.cumsum(f)
    fp = np.cumsum(np.maximum(f, 0))
    fm = np.cumsum(np.maximum(-f, 0))
    for X in (10**4, 10**5, 10**6):
        seg = path[: X + 1]
        D = seg.max() - seg.min()
        meas = max(fp[X], fm[X])
        results[(Q, X)] = (D, meas)
        d1 = results[(1, X)][0]
        print(f"Q={Q:>2} X={X:>8} D={D:10.2f} D/sqrtX={D/sqrt(X):6.3f} "
              f"meas/X={meas/X:7.4f} (1-1/logX={1-1/log(X):6.4f}) D_Q-D_1={D-d1:6.2f}")
    if Q == 30:
        # (B) Lemma 1.1 direct check
        CQ = float(sum(divisor_sigma(r) / totient(r) for r in range(1, 31)))
        print(f"\nC_30 = sum_(r<=30) sigma(r)/phi(r) = {CQ:.3f}")
        n = np.arange(N + 1)
        worst = 0.0
        for q in (2, 3, 4, 6, 7, 12, 30):
            phq = int(totient(q))
            for a in range(q):
                mask = (n % q == a).astype(float)
                mask[0] = 0.0
                S = np.cumsum(sharp * mask)  # sum_{n<=x, n=a(q)} Lambda^sharp
                main = (np.arange(N + 1) / phq) if gcd(a, q) == 1 else np.zeros(N + 1)
                dev = np.abs(S - main).max()
                worst = max(worst, dev)
                tag = "coprime" if gcd(a, q) == 1 else "NONcop "
                print(f"  q={q:>2} a={a:>2} ({tag}) max_x |sum - main| = {dev:8.3f}")
        print(f"\nLemma 1.1 worst deviation over all tested (q,a): {worst:.3f}  "
              f"(bound C_30 = {CQ:.3f}) -> {'PASS' if worst <= CQ else 'FAIL'}")
