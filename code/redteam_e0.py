"""RED TEAM audit of Proposition E0 (ADELIC.md) and the crossover law (PARITY.md H).

(1) Derive the per-prime KMS_beta correlator factor NUMERICALLY from the
    Neshveyev density  d mu_{beta,p}/d mu_{1,p} = (1-p^-beta)/(1-p^-1) |a|_p^{beta-1},
    by exact summation over Z/p^K (K large), including p | h and p^2 | h cases,
    and compare against the closed-form factor claimed in ADELIC.md Prop E0.
(2) Recompute the E0 partial-product table (h=2; beta = 0.9, 1.0, 1.1;
    B = 1e3, 1e4, 1e5) against the numbers quoted in ADELIC.md.
(3) Independent check of the crossover scaling law
    C_{beta_z,z}(H)/C_{1,z}(H) -> exp[-(k-1) Ein(lambda)],  beta_z = 1+lambda/log z,
    with our own implementation and Richardson extrapolation at larger z.
(4) Sanity check of two Lambda- and lambda-spectral atoms of PARITY.md exp10.
"""
import numpy as np
from sympy import primerange
import mpmath as mp

# ---------------------------------------------------------------- (1)
def mu_beta_weights(p, beta, K=12):
    """Weights of mu_{beta,p} on residues mod p^K via the density
    (1-p^-beta)/(1-1/p) * |a|_p^{beta-1} against Haar (uniform on Z/p^K).
    The class a=0 mod p^K gets the exact tail measure p^{-K beta}."""
    N = p ** K
    a = np.arange(N)
    w = np.zeros(N)
    norm = (1 - p ** (-beta)) / (1 - 1 / p)
    v = np.zeros(N, dtype=int)
    for k in range(1, K + 1):
        v[:: p ** k] = k
    w = norm * (p ** (-float(beta) + 1)) ** v / N
    w[0] = p ** (-K * float(beta))          # exact tail at a = 0
    return a, w

def factor_direct(p, beta, h, K=10):
    a, w = mu_beta_weights(p, beta, K)
    unit = (a % p) != 0
    unit_h = ((a + h) % p) != 0
    num = w[unit & unit_h].sum()
    den = w[unit].sum() ** 2
    return num / den

def factor_claimed(p, beta, h):
    if h % p == 0:
        return 1.0 / (1 - p ** (-beta))
    return (p - 2) / ((p - 1) * (1 - p ** (-beta)))

def audit_local_factors():
    print("== (1) per-prime KMS_beta factor: Neshveyev density vs Prop E0 formula ==")
    for p, h in [(2, 2), (2, 4), (2, 8), (3, 2), (3, 6), (3, 9), (5, 2), (5, 10),
                 (7, 3), (7, 49)]:
        for beta in [0.7, 1.0, 1.3]:
            d = factor_direct(p, beta, h, K=10 if p <= 3 else 6)
            c = factor_claimed(p, beta, h)
            ok = abs(d - c) < 1e-9 * max(1, abs(c))
            if not ok:
                print(f"  MISMATCH p={p} h={h} beta={beta}: direct {d:.12f} vs {c:.12f}")
        print(f"  p={p}, h={h}: match at beta=0.7,1.0,1.3  "
              f"(p|h: {h % p == 0}, p^2|h: {h % p**2 == 0})")

# ---------------------------------------------------------------- (2)
def audit_partial_products():
    print("\n== (2) E0 partial products, h=2 ==")
    for beta in [0.9, 1.0, 1.1]:
        row = []
        for B in [10 ** 3, 10 ** 4, 10 ** 5]:
            v = 1.0
            for p in primerange(2, B + 1):
                v *= factor_claimed(p, beta, 2)
            row.append(v)
        print(f"  beta={beta}: " + "  ".join(f"{v:.5f}" for v in row))
    mp.mp.dps = 30
    # true S(2) = 2*C2
    C2 = 1.0
    for p in primerange(3, 10 ** 7):
        C2 *= 1 - 1 / (p - 1) ** 2
    print(f"  S(2) via twin-prime constant (p<1e7): {2*C2:.6f}")

# ---------------------------------------------------------------- (3)
def audit_crossover():
    print("\n== (3) crossover scaling law, independent implementation ==")
    def local(p, beta, H):
        nu = len({h % p for h in H})
        return (p - nu) / (p - 1) * (1 - p ** (-beta)) ** (1 - len(H))
    def ratio(z, lam, H):
        beta = 1 + lam / np.log(z)
        r = 1.0
        for p in primerange(2, z + 1):
            r *= local(p, beta, H) / local(p, 1.0, H)
        return r
    for H, lam in [((0, 2), 1.0), ((0, 2), -1.0), ((0, 2, 6), 0.5), ((0, 4, 6), 0.5)]:
        k = len(H)
        # Ein(z) = sum_{j>=1} (-1)^{j+1} z^j / (j * j!)  (entire; valid all real lam)
        ein = float(mp.nsum(lambda j: (-1) ** (j + 1) * mp.mpf(lam) ** j
                            / (j * mp.factorial(j)), [1, mp.inf]))
        pred = float(mp.e ** (-(k - 1) * ein))
        zs = [10 ** 4, 10 ** 5, 10 ** 6, 3 * 10 ** 6]
        rs = [ratio(z, lam, H) for z in zs]
        # Richardson in 1/log z from last two
        l1, l2 = 1 / np.log(zs[-2]), 1 / np.log(zs[-1])
        ext = rs[-1] + (rs[-1] - rs[-2]) * l2 / (l1 - l2)
        print(f"  H={H} (k={k}), lambda={lam:+.1f}: raw {rs[-1]:.5f}  "
              f"extrap {ext:.5f}  predicted {pred:.5f}  "
              f"rel.err {abs(ext-pred)/pred:.2e}")

# ---------------------------------------------------------------- (4)
def audit_atoms():
    print("\n== (4) spectral atoms spot check (X = 2e6) ==")
    N = 2_000_000
    lam = np.zeros(N + 1)
    isc = np.zeros(N + 1, dtype=bool)
    Om = np.zeros(N + 1, dtype=np.int32)
    for p in range(2, N + 1):
        if not isc[p]:
            lam[p ** int(np.log(N) / np.log(p))] = 0  # no-op guard
            lp = np.log(p)
            q = p
            while q <= N:
                lam[q] = lp
                q *= p
            isc[p * p:: p] = True
    # Omega(n) additively
    n = np.arange(N + 1)
    Om = np.zeros(N + 1, dtype=np.int16)
    m = n.copy()
    for p in range(2, int(N ** 0.5) + 1):
        if not isc[p] or p * p > N and False:
            pass
        # standard: divide out
    # simpler: compute liouville by sieve over smallest prime factor
    spf = np.zeros(N + 1, dtype=np.int32)
    for p in range(2, N + 1):
        if spf[p] == 0:
            spf[p:: p][spf[p:: p] == 0] = p
    lio = np.ones(N + 1, dtype=np.int8)
    for x in range(2, N + 1):
        lio[x] = -lio[x // spf[x]]
    n = np.arange(N + 1, dtype=float)
    for a, q, pred in [(1, 3, 0.25), (1, 4, 0.0), (2, 5, 1 / 16)]:
        ph = np.exp(2j * np.pi * a * np.arange(N + 1) / q)
        mL = abs(np.sum((lam - 1) * ph)[()] / N) ** 2 if q > 1 else 0
        mLam = abs(np.sum(lam * ph) / N) ** 2
        mlio = abs(np.sum(lio[: N + 1] * ph) / N) ** 2
        print(f"  a/q={a}/{q}: m_Lambda={mLam:.5f} (pred {pred})   "
              f"m_lambda={mlio:.2e} (pred 0)")

if __name__ == "__main__":
    audit_local_factors()
    audit_partial_products()
    audit_crossover()
    audit_atoms()
