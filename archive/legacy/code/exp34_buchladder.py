#!/usr/bin/env python3
"""exp34_buchladder: the depth-side mirror of the K2 temperature ladder.

Temperature side (K2 II, proved): with beta_z = 1 + lambda/log z,
    D_z(lambda) = Ein(lambda) - log[delta zeta(1+delta)] + O(e^{-c sqrt(log z)}),
    delta = lambda/log z  -- finite-size ladder = zeta's Laurent (Stieltjes) jet.

Depth side (notes/BUCHSTAB_LADDER.md):

  (A) Closed form (Theorem D1): with s = 1 + delta, delta = lambda/log y,
        zeta(s) * prod_{p<=y} (1 - p^{-s})
          = e^{-gamma} e^{Ein(lambda)} / lambda * (1 + O(e^{-c sqrt(log y)}))
          = 1 + omegahat(lambda),
      where omegahat(s) = int_1^inf omega(u) e^{-su} du (Buchstab transform),
      1 + omegahat(s) = exp(E_1(s)).  The Stieltjes ladder cancels EXACTLY
      between zeta(s) and the temperature ladder of the truncated product:
      the depth closed form has NO 1/log y ladder.  Verified here: |LHS/RHS-1|
      falls at PNT speed with no 1/log y plateau.

  (B) Interval (archimedean) ladder: mean of nu_W over [1,X], W = prod_{p<=y},
      y = X^{1/u}:
        (1/X) sum_{n<=X} nu_W(n)
          = e^gamma omega(u) [1 + c1(u)/log X + c2(u)/log^2 X + ...],
        c_k(u) = (-u)^k omega^{(k)}(u) / omega(u),
        c1(u)  = -u omega'(u)/omega(u) = 1 - omega(u-1)/omega(u)
      (delay DE u omega' + omega = omega(u-1)).  On (1,2]: c1 = 1 (li ladder);
      on (2,3]: c1(u) = 1 - u/((u-1)(1+log(u-1))).  Coefficients are the
      omega-jet, NOT Stieltjes constants.  Numerically this factors into:
      (B1) the calculus ladder of the smooth de Bruijn model
             Phi_smooth(X,y) = 1 + int_1^u omega(v) y^v dv,
           verified to machine precision at large synthetic lambda = log y
           (all polynomial boundary layers die there);
      (B2) the sieve: Phi(X,y)/Phi_smooth(X,y) -> 1 at PNT (power-of-X) speed
           -- at accessible X this de Bruijn remainder is an accumulated
           li-vs-pi layer over the semiprime stratum, numerically comparable
           to the c2/log^2 X term, and it visibly shrinks.

Usage: python3 exp34_buchladder.py [--big]   (--big adds X = 3e7, 1e8)
Figure: figures/exp34_buchladder.png (Agg).
"""
import sys
import time
import math
import numpy as np
from scipy.integrate import quad

EG = 0.5772156649015328606  # Euler gamma
EXP_EG = math.exp(EG)

# ----------------------------------------------------------------------
# utilities
# ----------------------------------------------------------------------

def primes_upto(n):
    if n < 2:
        return np.array([], dtype=np.int64)
    s = np.ones(n + 1, dtype=bool)
    s[:2] = False
    for p in range(2, int(n ** 0.5) + 1):
        if s[p]:
            s[p * p:: p] = False
    return np.nonzero(s)[0].astype(np.int64)


def rough_count(X, ps):
    """Phi(X,y) = #{n <= X : p|n => p > y}, ps = primes <= y.  Counts n=1."""
    a = np.ones(X + 1, dtype=bool)
    a[0] = False
    for p in ps:
        a[p:: p] = False
    return int(np.count_nonzero(a[1: X + 1]))


def Ein(x):
    s, t = 0.0, 1.0
    for k in range(1, 60):
        t *= -x / k
        s -= t / k
    return s


# ----------------------------------------------------------------------
# Buchstab omega, its jet, and the ladder coefficients (exact on (1,3])
# ----------------------------------------------------------------------

def omega(u):
    if u < 1:
        return 0.0
    if u <= 2:
        return 1.0 / u
    if u <= 3:
        return (1.0 + math.log(u - 1.0)) / u
    raise ValueError("u > 3 not implemented")


def omega_jet(u, K=4):
    """[omega, ..., omega^(K)](u); left-limit jet at u = 2, 3."""
    if 1 < u <= 2:
        return [((-1) ** k) * math.factorial(k) / u ** (k + 1) for k in range(K + 1)]
    if 2 < u <= 3:
        om = (1.0 + math.log(u - 1.0)) / u
        d1 = (1.0 / (u - 1.0) - om) / u              # u om'   = om(u-1) - om
        d2 = (-1.0 / (u - 1.0) ** 2 - 2 * d1) / u    # u om''  = om'(u-1) - 2 om'
        d3 = (2.0 / (u - 1.0) ** 3 - 3 * d2) / u
        d4 = (-6.0 / (u - 1.0) ** 4 - 4 * d3) / u
        return [om, d1, d2, d3, d4][: K + 1]
    raise ValueError


def c_coeffs(u, K=4):
    """c_k(u) = (-u)^k omega^(k)(u)/omega(u), k = 1..K."""
    jet = omega_jet(u, K)
    return [((-u) ** k) * jet[k] / jet[0] for k in range(1, K + 1)]


def phi_smooth_over_X(u, lam):
    """Phi_smooth(X, y)/X for X = e^{u lam}, y = e^lam:
       e^{-u lam} + int_1^u omega(v) e^{-lam (u-v)} dv  (stable at any lam)."""
    I, _ = quad(lambda v: omega(v) * math.exp(-lam * (u - v)), 1.0, u,
                points=[2.0] if u > 2 else None, limit=300)
    return math.exp(-u * lam) + I


# ----------------------------------------------------------------------
# (A) Theorem D1
# ----------------------------------------------------------------------

def check_D1():
    print("=" * 76)
    print("(A) Theorem D1:  zeta(1+d) prod_{p<=y}(1-p^{-1-d}) = e^{-g}e^{Ein(l)}/l,"
          "  d = l/log y")
    print("=" * 76)
    from scipy.special import zeta as szeta
    rows = []
    for y in (10 ** 4, 10 ** 5, 10 ** 6, 10 ** 7):
        ps = primes_upto(y).astype(np.float64)
        L = math.log(y)
        for lam in (-1.0, 0.5, 1.0, 2.0):
            d = lam / L
            lhs = float(szeta(1.0 + d)) * math.exp(float(np.sum(np.log1p(-ps ** (-1.0 - d)))))
            rhs = math.exp(-EG) * math.exp(Ein(lam)) / lam
            rows.append((y, lam, lhs, rhs, lhs / rhs - 1.0))
            print(f"  y=10^{int(math.log10(y))}  lam={lam:+.1f}   LHS={lhs:.8f}"
                  f"  RHS={rhs:.8f}   LHS/RHS-1 = {lhs / rhs - 1.0:+.2e}")
    y = 10 ** 6
    ps = primes_upto(y).astype(np.float64)
    m = math.log(y) * math.exp(float(np.sum(np.log1p(-1.0 / ps))))
    print(f"  lam=0 endpoint (Mertens):  log y * prod(1-1/p) = {m:.8f}"
          f"   vs e^-gamma = {math.exp(-EG):.8f}   rel {m * math.exp(EG) - 1:+.2e}")
    return rows


# ----------------------------------------------------------------------
# (B1) machine-precision check of the calculus ladder on the smooth model
# ----------------------------------------------------------------------

def check_model_ladder(us):
    print("=" * 76)
    print("(B1) smooth-model ladder:  r_model(L) = (lam Phi_s/(X om) - 1) L -> c1(u),")
    print("     L = u lam;  successive Richardson gives c2, c3  (exact values shown)")
    print("=" * 76)
    res = {}
    for u in us:
        cs = c_coeffs(u)
        lams = np.array([20.0, 30.0, 45.0, 67.5, 101.25])
        r = []
        for lam in lams:
            ps_over_X = phi_smooth_over_X(u, lam)
            mean_over = lam * ps_over_X / omega(u)      # = mean/(e^g om) in the model
            r.append((mean_over - 1.0) * u * lam)
        r = np.array(r)
        L = u * lams
        # fit r = c1 + c2/L + c3/L^2 on the three largest L
        A = np.vander(1.0 / L[-3:], 3)
        c3f, c2f, c1f = np.linalg.solve(A, r[-3:])
        res[u] = (L, r, c1f, c2f, c3f)
        print(f"  u={u}:  c1_fit={c1f:+.8f}  (exact {cs[0]:+.8f},  err {c1f - cs[0]:+.1e})")
        print(f"          c2_fit={c2f:+.6f}    (exact {cs[1]:+.6f})   "
              f"c3_fit={c3f:+.4f}  (exact {cs[2]:+.4f})")
    return res


# ----------------------------------------------------------------------
# (B2) sieve vs smooth model
# ----------------------------------------------------------------------

def run_sieve(Xs, us):
    print("=" * 76)
    print("(B2) sieve:  r(X,u) = (mean/(e^g om(u)) - 1) log X   vs   smooth model;")
    print("     gap = de Bruijn remainder (accumulated li-vs-pi layer), -> 0 at")
    print("     power-of-X speed; at u=2 it is just li(X)-pi(X) etc.")
    print("=" * 76)
    out = {u: [] for u in us}
    for X in Xs:
        for u in us:
            t0 = time.time()
            y = X ** (1.0 / u)
            lam = math.log(X) / u
            ps = primes_upto(int(y + 1e-9))
            phi = rough_count(X, ps)
            WoverPhiW = float(np.exp(np.sum(np.log(ps / (ps - 1.0)))))
            om = omega(u)
            L = math.log(X)
            mean = WoverPhiW * phi / X
            r = (mean / (EXP_EG * om) - 1.0) * L
            phis_over_X = phi_smooth_over_X(u, lam)
            mean_s = WoverPhiW * phis_over_X
            r_s = (mean_s / (EXP_EG * om) - 1.0) * L
            rel = phi / (phis_over_X * X) - 1.0
            out[u].append((X, phi, r, r_s, rel))
            print(f"  X=10^{math.log10(X):.1f} u={u:<4} Phi={phi:<9d} r={r:+.5f}  "
                  f"r_smooth={r_s:+.5f}  Phi/Phi_s-1={rel:+.2e}  [{time.time()-t0:.1f}s]")
    return out


def analyze(out, us):
    print("=" * 76)
    print("(B2) de Bruijn remainder decay:  fit  log|Phi/Phi_s - 1| ~ a - b log X.")
    print("     b > 0 = power-of-X decay: any positive power beats every 1/log^k,")
    print("     which is what the ladder claim needs.  Expected scale: b ~ 1/2 at")
    print("     u=2 (prime-layer li-pi), b ~ 1/4 .. 1/(2u) for u>2 (semiprime layer).")
    print("=" * 76)
    for u in us:
        rows = out[u]
        X = np.array([q[0] for q in rows], dtype=float)
        rel = np.array([abs(q[4]) for q in rows], dtype=float)
        slope, a = np.polyfit(np.log(X), np.log(rel), 1)
        print(f"  u={u}: measured decay exponent b = {-slope:.3f}; "
              f"|rel| at X extremes: {rel[0]:.2e} -> {rel[-1]:.2e}")


def try_oracle(model_res, us):
    print("=" * 76)
    print("oracle recognition of the measured intercepts c1(u)")
    print("=" * 76)
    try:
        from oracle import recognize
    except Exception as e:
        print("  oracle unavailable:", e)
        return
    for u in us:
        c1f = model_res[u][2]
        print(f"  u={u}: recognize({c1f:.8f}) ...")
        try:
            hits = recognize(c1f, tol=1e-6)
            for expr, resd in hits[:3]:
                print(f"      {expr}   (resid {resd:.1e})")
            if not hits:
                print("      no hit in curated basis -- expected: "
                      "c1(u) = 1 - omega(u-1)/omega(u) involves log(u-1), "
                      "outside the program-constant basis")
        except Exception as e:
            print("      oracle error:", e)
        # direct closed-form comparison (the honest recognition)
        if u > 2:
            cf = 1.0 - u / ((u - 1.0) * (1.0 + math.log(u - 1.0)))
        else:
            cf = 1.0
        print(f"      closed form 1 - u/((u-1)(1+log(u-1))) = {cf:+.8f}"
              f"   (match {abs(cf - c1f):.1e})")


# ----------------------------------------------------------------------
# figure
# ----------------------------------------------------------------------

def figure(out, us, model_res, d1rows):
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    col = {2: "#0072B2", 2.5: "#D55E00", 3: "#009E73"}  # Okabe-Ito, fixed by u
    fig, (ax0, ax1, ax2) = plt.subplots(1, 3, figsize=(15.5, 4.6))

    # panel 0: smooth-model ladder at large L -> c1 intercepts
    for u in us:
        L, r, c1f, _, _ = model_res[u]
        c1 = c_coeffs(u)[0]
        ax0.plot(1.0 / L, r, "o-", color=col[u], lw=1.8, ms=6, label=f"u = {u}")
        ax0.plot(0.0, c1, "*", color=col[u], ms=14, zorder=5)
        ax0.annotate(f"c$_1$({u}) = {c1:+.5f}", (0.0006, c1 + 0.006),
                     color=col[u], fontsize=9, va="bottom")
    ax0.axvline(0, color="0.75", lw=0.8)
    ax0.set_xlabel("1 / log X")
    ax0.set_ylabel(r"$r_{\rm model}$ = (mean/$e^\gamma\omega$ − 1)·log X")
    ax0.set_title("(B1) smooth-model ladder, synthetic log X ≤ 300:\n"
                  "intercept = c₁(u) = 1 − ω(u−1)/ω(u)  (machine precision)")
    ax0.grid(alpha=0.25, lw=0.5)
    ax0.legend(fontsize=9, loc="center right")

    # panel 1: sieve vs smooth model at real X
    for u in us:
        rows = out[u]
        X = np.array([q[0] for q in rows], dtype=float)
        L = np.log(X)
        r = np.array([q[2] for q in rows])
        rs = np.array([q[3] for q in rows])
        c1 = c_coeffs(u)[0]
        ax1.plot(1.0 / L, r, "o", color=col[u], ms=6, label=f"u = {u} sieve")
        ax1.plot(1.0 / L, rs, "-", color=col[u], lw=2, alpha=0.75,
                 label=f"u = {u} smooth model")
        ax1.plot(0.0, c1, "*", color=col[u], ms=14, zorder=5)
    ax1.axvline(0, color="0.75", lw=0.8)
    ax1.set_xlabel("1 / log X")
    ax1.set_ylabel("r(X, u)")
    ax1.set_title("(B2) sieve (dots) vs smooth model (lines):\n"
                  "gap = accumulated li−π layer, closes at power-of-X speed")
    ax1.grid(alpha=0.25, lw=0.5)
    ax1.legend(fontsize=8, loc="center right")
    ax1.set_xlim(-0.003, None)

    # panel 2: Theorem D1 error decay
    ys = sorted(set(q[0] for q in d1rows))
    lcol = {-1.0: "#0072B2", 0.5: "#D55E00", 1.0: "#009E73", 2.0: "#CC79A7"}
    for lam in (-1.0, 0.5, 1.0, 2.0):
        e = [abs(q[4]) for q in d1rows if q[1] == lam]
        ax2.plot(np.log(ys), e, "o-", color=lcol[lam], lw=1.8, ms=5,
                 label=f"λ = {lam:+.1f}")
    ax2.set_yscale("log")
    ax2.set_xlabel("log y")
    ax2.set_ylabel("|LHS/RHS − 1|")
    ax2.set_title("(A) Theorem D1:  ζ(s)·∏$_{p\\leq y}$(1−p$^{-s}$) = e$^{-γ}$e$^{Ein(λ)}$/λ\n"
                  "no 1/log y ladder — Stieltjes cancellation is exact")
    ax2.grid(alpha=0.25, lw=0.5)
    ax2.legend(fontsize=9)

    fig.tight_layout()
    fig.savefig("../figures/exp34_buchladder.png", dpi=160)
    print("figure written: figures/exp34_buchladder.png")


def main():
    big = "--big" in sys.argv
    us = [2, 2.5, 3]
    d1rows = check_D1()
    model_res = check_model_ladder(us)
    Xs = [10 ** 5, 3 * 10 ** 5, 10 ** 6, 3 * 10 ** 6, 10 ** 7]
    if big:
        Xs += [3 * 10 ** 7, 10 ** 8]
    out = run_sieve(Xs, us)
    analyze(out, us)
    try_oracle(model_res, us)
    figure(out, us, model_res, d1rows)


if __name__ == "__main__":
    main()
