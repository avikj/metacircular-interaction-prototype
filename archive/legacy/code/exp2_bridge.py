"""Experiment 2: The Laplace-Mellin bridge and the APERTURE LAW.

P(z) = sum_n Lambda(n) e^{-nz},  Re z > 0.

Explicit formula (shift the Mellin contour of Gamma(s)(-zeta'/zeta)(s) z^{-s}):

  P(z) = 1/z - sum_rho Gamma(rho) z^{-rho} - log(2 pi) + R(z),

R(z) = contribution of trivial zeros & poles of Gamma at negative integers,
O(|z|) uniformly in |arg z| <= pi/2 - delta for small |z|.

Aperture law: with z = t + i theta, the term for zero rho = 1/2 + i gamma has size
  |Gamma(rho) z^{-rho}| ~ sqrt(2 pi) e^{-pi gamma/2} |z|^{-1/2} e^{gamma arg z}
                        ~ sqrt(2 pi/|z|) e^{-gamma arctan(t/theta)} .
So the zero spectrum is exponentially damped at theta=0 (heat kernel kills it),
and OPENS along the phase direction: zeros up to height  gamma ~ (theta/t) log(1/eps)
contribute at accuracy eps.  "Gap-phase resolution theta buys zeta zeros up to theta/t."

We verify: direct summation of P(t+i theta) vs the explicit formula truncated at
gamma_max, showing the error collapse at gamma_max ~ theta/t.
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"
FIG.mkdir(exist_ok=True)

def P_direct(z, lam):
    n = np.arange(len(lam))
    # sum Lambda(n) e^{-nz}; truncate where e^{-nt} < 1e-18
    return np.sum(lam * np.exp(-n * z))

def P_formula(z, gammas, n_trivial=40):
    """1/z - sum_rho Gamma(rho) z^{-rho} - log 2 pi + trivial-ish corrections.

    Nontrivial zeros in conjugate pairs: rho = 1/2 +- i gamma.
    Trivial part: poles of Gamma(s)(-zeta'/zeta)(s) at s = -1, -3, ... (simple,
    from Gamma) and s = -2, -4,... (double: Gamma pole x trivial zero pole).
    For |z| <= 0.2 these are tiny; we include the simple odd ones numerically
    via mpmath zeta and bound the rest.
    """
    rho = 0.5 + 1j * gammas
    terms = np.exp(loggamma(rho) - rho * np.log(z))
    ztermsum = np.sum(terms) + np.sum(np.exp(loggamma(np.conj(rho)) - np.conj(rho) * np.log(z)))
    val = 1.0 / z - ztermsum - np.log(2 * np.pi)
    # odd negative integers: Res_{s=-n} Gamma = (-1)^n/n!
    import mpmath as mp
    corr = 0
    for n in range(1, n_trivial, 2):
        c = ((-1) ** n / mp.factorial(n)) * (-mp.zeta(-n, derivative=1) / mp.zeta(-n) if mp.zeta(-n) != 0 else 0)
        # -zeta'/zeta at s=-n for odd n (zeta(-n) != 0 there)
        zv = mp.zeta(-n)
        zdv = mp.zeta(-n, derivative=1)
        c = ((-1) ** n / mp.factorial(n)) * (-zdv / zv)
        corr += complex(c) * z ** n
    # double poles at -2k: Laurent of Gamma(s)*(-z'/z)(s) around s=-2k gives
    # z^{2k}(a log z + b); coefficients ~ 1/(2k)! -- include leading k=1,2 numerically
    for k in range(1, 6):
        s0 = -2 * k
        eps = mp.mpf(1) / 10**8
        # residue of f(s) z^{-s} at double pole: lim d/ds [ (s-s0)^2 f(s) z^{-s} ]
        def g(s):
            return mp.gamma(s) * (-mp.zeta(s, derivative=1) / mp.zeta(s)) * ((s - s0) ** 2)
        # numerical derivative of h(s) = g(s) * z^{-s} at s0
        h = lambda s: g(s) * mp.e ** (-s * mp.log(z))
        d = (h(s0 + eps) - h(s0 - eps)) / (2 * eps)
        corr += complex(d)
    return val + corr

def main():
    t = 0.005
    lam = sieve_lambda(int(45 / t))
    gam = load_zeros()
    print(f"zeros available: {len(gam)}, max gamma = {gam[-1]:.1f}")

    thetas = [0.05, 0.15, 0.4]
    cutoffs = np.unique(np.concatenate([np.arange(2, 30), np.geomspace(30, 3000, 60).astype(int)]))
    fig, ax = plt.subplots(1, 2, figsize=(12, 4.5))
    for th in thetas:
        z = t + 1j * th
        direct = P_direct(z, lam)
        errs = []
        for K in cutoffs:
            approx = P_formula(z, gam[: K])
            errs.append(abs(approx - direct) / abs(direct))
        errs = np.array(errs)
        gmax = gam[cutoffs - 1]
        ax[0].semilogy(gmax, errs, label=f"theta={th}, theta/t={th/t:.0f}")
        ax[0].axvline(th / t, ls=":", color="gray")
        # find gamma where error first < 1e-6
        idx = np.argmax(errs < 1e-6) if (errs < 1e-6).any() else None
        need = gam[cutoffs[idx] - 1] if idx else np.nan
        print(f"t={t}, theta={th}: theta/t={th/t:6.0f}, rel-err<1e-6 achieved at gamma_max ~ {need:8.1f}"
              f"  (ratio {(need*t/th):.2f} x theta/t)" if idx else f"theta={th}: not converged")
        errs_pred = np.exp(-gmax * np.arctan(t / th))
        ax[0].semilogy(gmax, errs_pred * errs[0] / errs_pred[0], lw=0.7, ls="--", color="k")
    ax[0].set_xlabel(r"$\gamma_{\max}$ (zeros used up to height)")
    ax[0].set_ylabel("relative error of explicit formula")
    ax[0].set_title(f"Aperture law: error ~ exp(-gamma arctan(t/theta)), t={t}\n"
                    "dashed: predicted decay; dotted verticals at theta/t")
    ax[0].legend(fontsize=8)

    # panel 2: the field |P(t+i theta)| vs theta, direct vs formula, showing
    # zeros are needed to reproduce the phase-direction structure
    th_grid = np.linspace(0.001, 1.0, 400)
    direct_v = np.array([P_direct(t + 1j * th, lam) for th in th_grid])
    K_show = [0, 20, 200, 2000]
    for K in K_show:
        fv = np.array([P_formula(t + 1j * th, gam[:K] if K else gam[:0]) for th in th_grid])
        ax[1].semilogy(th_grid, np.abs(direct_v - fv) / np.abs(direct_v), label=f"K={K} zeros", lw=0.9)
    ax[1].set_xlabel(r"$\theta$")
    ax[1].set_ylabel("relative error")
    ax[1].set_title("More phase aperture requires more zeros")
    ax[1].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(FIG / "exp2_aperture.png", dpi=140)
    print("saved figures/exp2_aperture.png")

if __name__ == "__main__":
    main()
