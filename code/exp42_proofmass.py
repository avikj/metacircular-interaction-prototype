"""exp42: proof-mass instantiation of the noisy-axiom conservation theorem.

Companion to notes/PROOF_MASS.md (Theorems PM1-PM6), evaluating one finite
box-and-slab LP family at X = 2*10^6 on exp41's lambda pipeline.  The prime,
twin, and swap cross-checks are exact integer identities.  Budgets involving
N/q or log N, the reported ratios, and kappa are float64 diagnostics, not an
exact arithmetic certificate.

Frame.  States nu = w dn on [1,N] with 0 <= w <= 2.  Axiom family: AP counts
A_{q,a}(nu) = sum_{n<=N, n=a(q)} w(n), asserted value b_{q,a} = N/q, budget
R_q.  Charge chi is lambda (prime frame, target 1_P, true state (1-lambda)dn)
or c2(n) = lambda(n)lambda(n+2) (twin frame, target 1_{twin}, true state
(1+c2)dn).  Per-axiom integer sums are computed exactly at this scale:

    delta_{q,a} = |sum_{n=a(q)} chi(n)|          (true charge of the axiom)
    e_{q,a}     = |#{n=a(q)} - N/q| < 1          (reference offset)
    m_{q,a}     = R_q - e_{q,a}                  (margin at the reference)

Budget schemes R_q = (N/q) / (log N)^A, A in {0,1,2}, are selected centered
baselines for this numerical experiment.  Even A=0 is not the universal box
budget around N/q: residue-class endpoint effects require N/q+O(1), with
N/q+2 a safe uniform choice for 0 <= w <= 2.  A=1,2 model BV_lambda-scale
budgets (available for the lambda frame only on average / off the bad set;
not known for the c2 frame).

Reported per (frame, theta, A), family = all (q,a) with
3 <= q <= floor(N^theta):

  t*    = min m_{q,a}/delta_{q,a}   -- largest symmetric radius r for which
          every nu_t with |t| <= r satisfies every noisy axiom (PM3; t* >= 1
          means both endpoints are feasible and PM2 gives beta <= 0 inside
          this finite affine LP cone).
  exch  = min R_q/delta_{q,a}       -- mass exchange rate: any derivation
          certifying beta pays dual mass M = sum |c_j| R_j >= beta * exch
          (PM5); relative to an explicitly selected certified baseline this
          is the PM6 reparameterization constant.
  kappa = max delta_{q,a}/sqrt(N_chi/q) -- flatness constant of the charge.

Output: data/exp42_out.txt, figures/exp42_proofmass.png.
"""
import sys, os
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pairfield import sieve_primes

X = int(sys.argv[1]) if len(sys.argv) > 1 else 2_000_000


def liouville2(X):
    """Same factor-count sieve as exp41 (re-run, not imported: exp41 is a script)."""
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


lam = liouville2(X)
isp = sieve_primes(X).astype(bool)
pi_X = int(isp[1:].sum())
c2 = (lam[1:X - 1] * lam[3:X + 1]).astype(np.float64)  # c2(n), n = 1..X-2
twin = isp[1:X - 1] & isp[3:X + 1]
pi2_X = int(twin.sum())
N2 = X - 2

out = [f"# exp42: proof-mass instantiation, X={X}"]
out.append(f"sum lambda = {int(lam[1:].sum())}, pi(X) = {pi_X}, pi2(X) = {pi2_X}")

# exact cross-checks against exp41 (same arithmetic ground truth)
if X == 2_000_000:
    assert int(lam[1:].sum()) == -1234
    assert 2 * pi_X == 297866
    assert 2 * pi2_X == 29742
    assert int((1 - c2)[twin].sum()) == 0          # anti-twin state kills the target
    assert int((1 + c2)[twin].sum()) == 2 * pi2_X  # twin-charged state doubles it
    out.append("exp41 cross-checks: PASS (sum lambda, 2pi, 2pi2, swap identities)")

# ---- per-(q,a) charge/offset tables ----------------------------------------
QMAX = int(X ** 0.5)  # 1414 at X = 2e6
nn = np.arange(1, X + 1, dtype=np.int64)
lam1 = lam[1:].astype(np.float64)

delta_lam, delta_c2, e_lam, e_c2 = {}, {}, {}, {}
for q in range(3, QMAX + 1):
    r = nn % q
    cnt = np.bincount(r, minlength=q).astype(np.float64)
    delta_lam[q] = np.abs(np.bincount(r, weights=lam1, minlength=q))
    e_lam[q] = np.abs(cnt - X / q)
    r2 = r[:N2]
    cnt2 = np.bincount(r2, minlength=q).astype(np.float64)
    delta_c2[q] = np.abs(np.bincount(r2, weights=c2, minlength=q))
    e_c2[q] = np.abs(cnt2 - N2 / q)

# ---- evaluate schemes -------------------------------------------------------
def family_stats(delta, e, Ntot, Q, A):
    """Numerical t*, exchange ratio, and flatness for a selected budget."""
    tstar, exch, kappa = np.inf, np.inf, 0.0
    arg_t = arg_x = None
    log_ntot = np.log(Ntot)
    for q in range(3, Q + 1):
        R = (Ntot / q) / log_ntot ** A
        d, ee = delta[q], e[q]
        pos = d > 0
        if pos.any():
            ratio_t = (R - ee[pos]) / d[pos]
            ratio_x = R / d[pos]
            i = int(np.argmin(ratio_t))
            j = int(np.argmin(ratio_x))
            if ratio_t[i] < tstar:
                tstar, arg_t = float(ratio_t[i]), q
            if ratio_x[j] < exch:
                exch, arg_x = float(ratio_x[j]), q
        k = float((d / np.sqrt(Ntot / q)).max())
        kappa = max(kappa, k)
    return tstar, arg_t, exch, arg_x, kappa


frames = {
    "prime (chi=lambda)": (delta_lam, e_lam, float(X), pi_X),
    "twin  (chi=c2)":     (delta_c2, e_c2, float(N2), pi2_X),
}
thetas = [0.40, 0.45, 0.50]
out.append("diagnostic status: integer target/swap checks exact; ratios and kappa float64")
out.append("selected budgets: R_q=(N/q)/(log N)^A; safe universal A=0 box budget is N/q+2")
out.append("")
out.append("frame                theta   Q      A   t*        exch      kappa   beta cap (PM3)")
results = {}
for fname, (delta, e, Ntot, target) in frames.items():
    for th in thetas:
        Q = min(QMAX, int(X ** th))
        for A in (0, 1, 2):
            tstar, qt, exch, qx, kappa = family_stats(delta, e, Ntot, Q, A)
            cap = 0.0 if tstar >= 1 else (1 - max(tstar, 0.0)) * target
            verdict = "beta <= 0 (PM2: swap feasible)" if tstar >= 1 else \
                f"beta <= {cap:.0f} (= (1-t*)*{target})"
            out.append(f"{fname:20s} {th:.2f}  {Q:5d}  {A}  {tstar:8.3f}  "
                       f"{exch:8.3f}  {kappa:5.2f}   {verdict}")
            results[(fname, th, A)] = (tstar, qt, exch, qx, kappa, Q)

# ---- headline: twin frame at theta = 1/2 - eps ------------------------------
th = 0.45
tstar, qt, exch, qx, kappa, Q = results[("twin  (chi=c2)", th, 0)]
out.append("")
out.append(f"HEADLINE (twin frame, theta = {th} = 1/2 - eps, Q = {Q},")
out.append("          selected centered budget R_q=N/q; numerical finite-X evaluation):")
out.append(f"  symmetric feasible radius for nu_t = (1 + t*c2)dn:  t* = {tstar:.3f}")
out.append(f"    (attained at q = {qt}; t* >= 1, so BOTH nu_+1 and nu_-1 satisfy every")
out.append(f"     noisy axiom, with {tstar:.1f}x slack -> PM2: beta <= 0, no positive")
out.append("     derivation in this finite box-and-slab LP cone certifies a positive bound)")
out.append(f"  mass exchange rate: min_j R_j/delta_j = {exch:.3f} (attained at q = {qx})")
out.append(f"    -> PM5/PM6: any derivation certifying beta (using any sound sharpened")
out.append(f"       budgets s_j*R_j) satisfies  M(D) * Gamma(D) >= beta * {exch:.3f},")
out.append(f"       Gamma = max_j 1/s_j the oracle sharpening factor.")
out.append(f"  charge flatness kappa = {kappa:.2f}  (sqrt-cancellation scale, all q <= {Q})")
out.append(f"  at separation-scale certification beta = pi2/2 = {pi2_X // 2}:")
out.append(f"       M * Gamma >= {0.5 * pi2_X * exch:.3e}")
out.append("")
out.append("conditional asymptotic projection of min_j F_j/delta_j (PM6),")
out.append("assuming CH_theta flatness delta <= kappa*sqrt(N/q):")
for XX in (2e6, 1e9, 1e12):
    v0 = XX ** ((1 - 0.45) / 2) / kappa
    v1 = XX ** ((1 - 0.5) / 2) / (kappa * np.log(XX))
    out.append(f"  X = {XX:.0e}:  theta=0.45,A=0: {v0:10.1f}   theta=0.50,A=1: {v1:10.1f}")

# ---- figure -----------------------------------------------------------------
try:
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    qs = np.arange(3, QMAX + 1)
    dmax = np.array([delta_c2[q].max() / np.sqrt(N2 / q) for q in qs])
    fig, ax = plt.subplots(figsize=(7.2, 4.6))
    ax.scatter(qs, dmax, s=3, alpha=0.35, color="#30588c",
               label=r"max$_a\,\delta_{q,a}/\sqrt{N/q}$  (pair charge $c_2$)")
    for A, c in ((0, "#b8443c"), (1, "#c98a2d"), (2, "#5b8c4a")):
        ax.plot(qs, np.sqrt(N2 / qs) / np.log(N2) ** A, color=c, lw=1.4,
                label=rf"budget $R_q/\sqrt{{N/q}}$, $A={A}$")
    ax.set_xscale("log"); ax.set_yscale("log")
    ax.set_xlabel("modulus q"); ax.set_ylabel(r"units of $\sqrt{N/q}$")
    ax.set_title(f"exp42: charge vs budget, X={X}  "
                 "(axiom crosses C2 threshold where budget dips into the band)")
    ax.legend(fontsize=8, loc="lower left")
    fig.tight_layout()
    fig.savefig(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..",
                             "figures", "exp42_proofmass.png"), dpi=130)
    out.append("figure: figures/exp42_proofmass.png")
except Exception as err:  # figure is optional
    out.append(f"figure skipped: {err}")

txt = "\n".join(out)
print(txt)
open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "data",
                  "exp42_out.txt"), "w").write(txt + "\n")
