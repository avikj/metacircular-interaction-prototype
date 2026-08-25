"""
exp27: correlation of the Liouville function against random sieve circuits.

Companion to notes/LENS_CIRCUIT.md (circuit-ladder proof of concept,
BLINDSPOTS.md blind spot 2, task 'circuit ladder: unconditional
lambda-orthogonality', owner fleet-circuit).

Classes measured (all depth-2 over the divisibility basis):
  - pure unions: OR of S literals 1_{q | n+a}, q uniform in [2,Q];
  - AND-blocks:  OR of S ANDs of two literals (moduli lcm structure);
  - BV-window:   OR of S literals at prime moduli q in [500,1400] ~ X^{1/2-eps}
                 (the Theorem-2 regime of the note).

For each random circuit f we record
    corr(f)  = |sum_{n<=X} lambda(n) f(n)|,
    bench(f) = sqrt(||f||_1) = sqrt(#{n<=X : f(n)=1}),
    ratio    = corr/bench,
i.e. the correlation in units of Bernoulli square-root cancellation
(under the random model, ratio is |N(0,1)|-distributed: median .674,
mean .798, max over T trials ~ sqrt(2 log T)).

Output: table of median/max ratio per (family, S, Q) cell over T trials,
plus figures/exp27_circuit.png.

X = 2e6, T = 200 trials/cell, seed fixed.  Runtime ~ a few minutes.
"""

import numpy as np

X = 2_000_000
T = 200
SEED = 27
rng = np.random.default_rng(SEED)

# ---------------------------------------------------------------- lambda sieve
def liouville(X):
    """Omega(n) additively via numpy slicing; lambda = (-1)^Omega."""
    omega = np.zeros(X + 1, dtype=np.int8)
    is_comp = np.zeros(X + 1, dtype=bool)
    for p in range(2, X + 1):
        if is_comp[p]:
            continue
        is_comp[p * p :: p] = True
        pk = p
        while pk <= X:
            omega[pk::pk] += 1
            if pk > X // p:
                break
            pk *= p
    lam = np.where(omega % 2 == 0, 1, -1).astype(np.int8)
    lam[0] = 0
    return lam

print("sieving lambda up to", X, "...")
lam = liouville(X)
n_idx = np.arange(X + 1)
lam_sum = int(lam[1:].sum())
print(f"  check: sum lambda = {lam_sum} (|.| < sqrt X = {int(X**0.5)})")

primes = np.nonzero(
    np.concatenate([[False, False], ~np.array(
        [any(k % p == 0 for p in range(2, int(k**0.5) + 1)) for k in range(2, 1500)]
    )])
)[0]
bv_primes = primes[(primes >= 500) & (primes <= 1400)]

# ---------------------------------------------------------------- circuits
def literal(q, a):
    """boolean array of 1_{q | n+a} for n = 0..X, via strided writes (O(X/q))"""
    m = np.zeros(X + 1, dtype=bool)
    m[(-a) % q :: q] = True
    return m

def or_literal_inplace(f, q, a):
    """f |= 1_{q | n+a} without allocating (O(X/q))"""
    f[(-a) % q :: q] = True

def sample_circuit(family, S, Q):
    """returns boolean array f over n=0..X (index 0 unused: lam[0]=0)."""
    f = np.zeros(X + 1, dtype=bool)
    if family == "union":          # OR of S literals
        for _ in range(S):
            q = int(rng.integers(2, Q + 1))
            a = int(rng.integers(0, q))
            or_literal_inplace(f, q, a)
    elif family == "andblock":     # OR of S (AND of 2 literals)
        for _ in range(S):
            q1 = int(rng.integers(2, Q + 1))
            q2 = int(rng.integers(2, Q + 1))
            a1 = int(rng.integers(0, q1))
            a2 = int(rng.integers(0, q2))
            # AND of two literals = CRT class mod lcm (or empty): do it exactly
            g = int(np.gcd(q1, q2))
            r1, r2 = (-a1) % q1, (-a2) % q2
            if (r1 - r2) % g != 0:
                continue                      # inconsistent: AND identically 0
            L = q1 // g * q2                  # lcm
            # solve n = r1 (q1), n = r2 (q2): n = r1 + q1*t, q1*t = r2-r1 (q2)
            t = ((r2 - r1) // g * pow(q1 // g, -1, q2 // g)) % (q2 // g)
            r = (r1 + q1 * t) % L
            if r <= X:
                f[r::L] = True
    elif family == "bvwindow":     # OR of S literals at prime moduli ~ X^{1/2-}
        qs = rng.choice(bv_primes, size=S, replace=False if S <= len(bv_primes) else True)
        for q in qs:
            a = int(rng.integers(0, q))
            or_literal_inplace(f, int(q), a)
    return f

def cell(family, S, Q, trials=T):
    ratios = np.empty(trials)
    for t in range(trials):
        f = sample_circuit(family, S, Q)
        mass = int(f[1:].sum())
        if mass == 0:
            ratios[t] = 0.0
            continue
        corr = abs(int(lam[f].sum()))
        ratios[t] = corr / np.sqrt(mass)
    return np.median(ratios), ratios.max(), ratios

# ---------------------------------------------------------------- run
results = {}
rows = []
print(f"\n{'family':>9} {'S':>3} {'Q':>7} | {'median':>7} {'max':>6}   "
      f"(null: median 0.674, E max_{T} ~ {np.sqrt(2*np.log(T)):.2f})")
for family, Qs in [("union", [100, 10_000]), ("andblock", [100, 10_000]),
                   ("bvwindow", [None])]:
    for Q in Qs:
        for S in [4, 16, 64]:
            med, mx, ratios = cell(family, S, Q if Q else 0)
            results[(family, S, Q)] = ratios
            qlabel = str(Q) if Q else "p~[500,1400]"
            print(f"{family:>9} {S:>3} {qlabel:>7} | {med:7.3f} {mx:6.3f}")
            rows.append((family, S, qlabel, med, mx))

# aggregate: any cell whose max ratio is inconsistent with the half-normal null?
import scipy.stats as st
print("\nnull-consistency (p-value of observed max under |N(0,1)|^T):")
for (family, S, Q), ratios in results.items():
    mx = ratios.max()
    # P(max of T half-normals > mx)
    p = 1 - (2 * st.norm.cdf(mx) - 1) ** T
    flag = "  <-- signal?" if p < 0.01 else ""
    print(f"  {family:>9} S={S:<3} Q={str(Q):>6}: max={mx:5.2f}  p={p:6.3f}{flag}")

# ---------------------------------------------------------------- figure
try:
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    fig, axes = plt.subplots(1, 3, figsize=(13, 4), sharey=True)
    fams = [("union", [100, 10_000]), ("andblock", [100, 10_000]),
            ("bvwindow", [None])]
    for ax, (family, Qs) in zip(axes, fams):
        for Q in Qs:
            meds = [np.median(results[(family, S, Q)]) for S in [4, 16, 64]]
            mxs = [results[(family, S, Q)].max() for S in [4, 16, 64]]
            lbl = f"Q={Q}" if Q else "q prime ~ X^(1/2-)"
            ax.plot([4, 16, 64], meds, "o-", label=f"median, {lbl}")
            ax.plot([4, 16, 64], mxs, "s--", label=f"max, {lbl}")
        ax.axhline(0.674, color="gray", lw=0.8)
        ax.axhline(np.sqrt(2 * np.log(T)), color="gray", lw=0.8, ls=":")
        ax.set_xscale("log", base=2)
        ax.set_xticks([4, 16, 64]); ax.set_xticklabels(["4", "16", "64"])
        ax.set_xlabel("size S")
        ax.set_title(family)
        ax.legend(fontsize=7)
    axes[0].set_ylabel(r"$|\sum \lambda f| / \sqrt{\|f\|_1}$")
    fig.suptitle(
        r"exp27: $\lambda$ vs random depth-2 sieve circuits, $X=2\cdot 10^6$ "
        "(gray: half-normal median / expected max of 200 trials)")
    fig.tight_layout()
    fig.savefig("../figures/exp27_circuit.png", dpi=130)
    print("\nfigure -> figures/exp27_circuit.png")
except Exception as e:  # matplotlib optional
    print("figure skipped:", e)
