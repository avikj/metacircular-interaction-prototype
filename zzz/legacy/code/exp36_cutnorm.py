# exp36: interval cut norm of the flat pair array W = Lambda^flat (x) Lambda^flat
# (rank one, so ||W||_int = D(X)^2 with D(X) = sup over intervals I of |psi^flat(I)|
# = osc_{[0,X]} psi^flat = max - min of the partial-sum path).
#
# Checks, for Q = 1 and Q = 30:
#   (i)  D(X) / sqrt(X)  and  D(X) / (sqrt(X) log^2 X)  -- RH scale (LENS_REGULARITY Thm 1);
#   (ii) the measurable-cut scale  max(sum f_+, sum f_-) / X  -- degeneration Lemma 2:
#        should tend to 1 (Q=1) / stay ~ 1 (Q=30), i.e. measurable cut norm ~ X^2, no decay;
#   (iii) Q-stability: D_Q(X) - D_1(X) = O_Q(1) (Lemma 1.1 corollary).
#
# Pure sieve, no zeros table needed. Runtime ~ 15 s at N = 10^7.

import numpy as np

N = 10**7

# ---- von Mangoldt via sieve ----
lam = np.zeros(N + 1)
is_comp = np.zeros(N + 1, dtype=bool)
for p in range(2, int(N**0.5) + 1):
    if not is_comp[p]:
        is_comp[p * p:: p] = True
primes = np.nonzero(~is_comp)[0][2:]  # skip 0,1
lam[primes] = np.log(primes)
for p in primes[primes <= int(N**0.5)]:
    pk = p * p
    while pk <= N:
        lam[pk] = np.log(p)
        pk *= p

# ---- Lambda^sharp_Q on residues ----
def mu_phi(q):
    m, ph, qq = 1, 1, q
    for p in range(2, q + 1):
        if qq % p == 0:
            e = 0
            while qq % p == 0:
                qq //= p
                e += 1
            if e > 1:
                return 0, None
            m, ph = -m, ph * (p - 1)
    return m, ph

def c_q_residues(q):
    # c_q(n) = sum_{d | (q,n)} d mu(q/d), as a vector over n mod q
    out = np.zeros(q)
    for r in range(q):
        g = np.gcd(q, r) if r else q
        s = 0
        for d in range(1, g + 1):
            if g % d == 0:
                m, _ = mu_phi(q // d)
                if m is not None:
                    s += d * m
        out[r] = s
    return out

def lam_sharp(Q):
    n = np.arange(N + 1)
    out = np.ones(N + 1)  # q = 1 term
    for q in range(2, Q + 1):
        m, ph = mu_phi(q)
        if m == 0 or m is None:
            continue
        out += (m / ph) * np.take(c_q_residues(q), n % q)
    return out

print(f"{'Q':>3} {'X':>10} {'D(X)':>12} {'D/sqrt(X)':>10} {'D/(sqrt X log^2 X)':>18} "
      f"{'meas-cut/X':>10} {'D_Q - D_1':>10}")
D1 = {}
for Q in (1, 30):
    f = lam.copy()
    f[1:] -= lam_sharp(Q)[1:]
    f[0] = 0.0
    path = np.cumsum(f)
    hi = np.maximum.accumulate(path)
    lo = np.minimum.accumulate(path)
    fp = np.cumsum(np.maximum(f, 0))
    fm = np.cumsum(np.maximum(-f, 0))
    for X in (10**4, 10**5, 10**6, 10**7):
        D = hi[X] - lo[X]          # sup over intervals I subset [1,X] of |psi_flat(I)|
        meas = max(fp[X], fm[X])   # sup over measurable S of |sum_S f| (Lemma 2)
        if Q == 1:
            D1[X] = D
        print(f"{Q:>3} {X:>10} {D:>12.2f} {D/np.sqrt(X):>10.3f} "
              f"{D/(np.sqrt(X)*np.log(X)**2):>18.5f} {meas/X:>10.4f} {D - D1[X]:>10.2f}")
