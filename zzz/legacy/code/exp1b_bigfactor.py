"""Exhaustive small-X check + large-X irreducibility of prime polynomials."""
import time
from flint import fmpz_poly
from pairfield import sieve_primes
import numpy as np

def prime_poly(X):
    isp = sieve_primes(X)
    ps = np.nonzero(isp)[0]
    c = [0]*(ps[-1]-ps[0]+1)
    for p in ps: c[p-ps[0]] = 1
    return fmpz_poly(c), len(ps)

# exhaustive: every prime cutoff X up to 2000
isp = sieve_primes(2000)
primes = np.nonzero(isp)[0]
bad = []
for X in primes:
    f, k = prime_poly(int(X))
    if f.degree() <= 0: continue
    _, facs = f.factor()
    nf = sum(e for _, e in facs)
    if nf > 1:
        bad.append((int(X), [(str(p)[:60], e) for p, e in facs]))
print(f"checked all prime cutoffs X <= 2000: reducible cases: {len(bad)}")
for b in bad[:10]: print("  ", b)

# large X
for X in [5000, 10000, 20000]:
    t0=time.time(); f,k = prime_poly(X); _, facs = f.factor()
    nf = sum(e for _,e in facs)
    print(f"X={X}: degree {f.degree()}, pi(X)={k}, factors={nf}, time={time.time()-t0:.1f}s", flush=True)
