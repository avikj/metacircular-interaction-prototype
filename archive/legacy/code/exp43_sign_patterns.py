"""exp43: sign-pattern census of the Liouville point (FOREST.md's fruit-fly).

Counts frequencies of all 2^k sign patterns of (lambda(n+1),...,lambda(n+k))
for k = 2..6 up to X, reporting max |freq - 2^-k| per k, plus the least
frequent pattern (a missing pattern at any k would falsify Chowla).
"""
import sys, os
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

X = int(sys.argv[1]) if len(sys.argv) > 1 else 10_000_000

def liouville(X):
    omega_par = np.zeros(X + 1, dtype=np.int8)
    rem = np.arange(X + 1, dtype=np.int64)
    for p in range(2, X + 1):
        if rem[p] == p:
            idx = np.arange(p, X + 1, p)
            while len(idx):
                omega_par[idx] ^= 1
                rem[idx] //= p
                idx = idx[rem[idx] % p == 0]
    lam = np.where(omega_par == 0, 1, -1).astype(np.int8)
    lam[0] = 0
    return lam

lam = liouville(X)
bits = (lam[1:] == 1).astype(np.int64)   # bit(n) = 1 iff lambda(n) = +1, n = 1..X

out = [f"# exp43: Liouville sign-pattern census, X={X}"]
for k in range(2, 7):
    # code(n) = sum_{j<k} bit(n+j) * 2^j  for n = 1 .. X-k+1
    N = X - k + 1
    code = np.zeros(N, dtype=np.int64)
    for j in range(k):
        code += bits[j:j+N] << j
    counts = np.bincount(code, minlength=2**k).astype(float)
    freqs = counts / N
    dev = np.abs(freqs - 2.0**-k)
    worst = int(np.argmax(dev))
    least = int(np.argmin(counts))
    out.append(
        f"k={k}: max|freq-2^-k| = {dev.max():.2e} (pattern {worst:0{k}b}), "
        f"min count = {int(counts[least])} (pattern {least:0{k}b}, freq {freqs[least]:.6f}); "
        f"all {2**k} patterns present: {bool((counts > 0).all())}"
    )

txt = "\n".join(out)
print(txt)
open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "data", "exp43_out.txt"), "w").write(txt + "\n")
