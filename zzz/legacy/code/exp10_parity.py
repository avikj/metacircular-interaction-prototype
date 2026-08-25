"""Experiment 10: the parity sector is the atomless part of the additive spectrum.

Wiener-Bohr spectral atoms at rational frequency a/q:
    m_f(a/q) = lim_X | (1/X) sum_{n<=X} f(n) e(a n/q) |^2 .

(i)  f = Lambda:  atoms persist,  m = mu(q)^2/phi(q)^2  (Siegel-Walfisz level;
     conjecturally (HL) these atoms EXHAUST the spectrum of Lambda-1:
     sigma is purely atomic on Q/Z with exactly these masses).
(ii) f = lambda (Liouville): every atom is ZERO (Davenport, unconditionally),
     and Chowla's conjecture is equivalent (ALKPR) to sigma_lambda = Lebesgue.

So divisibility statistics (the BC/profinite block) see all of Lambda's
conjectural spectrum and NONE of lambda's: the sieve parity barrier is the
statement that the atomic sector never controls the atomless sector.
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from sympy import mobius, totient
from pairfield import sieve_lambda

FIG = Path(__file__).resolve().parent.parent / "figures"

def sieve_liouville(N):
    """lambda(n) = (-1)^Omega(n) via smallest-prime-factor sieve."""
    Om = np.zeros(N + 1, dtype=np.int32)
    m = np.arange(N + 1)
    work = m.copy()
    for p in range(2, N + 1):
        if work[p] == p:                     # p prime (not yet reduced)
            pk = p
            while pk <= N:
                Om[pk::pk] += 1
                pk *= p
            work[p::p] = 1                    # mark composites cheaply
    lam = np.where(m >= 1, (-1) ** (Om % 2), 0).astype(float)
    lam[0] = 0
    return lam

def main():
    NMAX = 2_000_000
    LamV = sieve_lambda(NMAX)                      # von Mangoldt
    LioV = sieve_liouville(NMAX)                   # Liouville
    # normalize Lambda to mean ~1 not needed; atom def uses raw mean
    Xs = np.geomspace(1e4, NMAX, 40).astype(int)
    tests = [(1, 1), (1, 2), (1, 3), (1, 4), (1, 6), (2, 5)]
    fig, ax = plt.subplots(1, 2, figsize=(12.5, 4.6), sharey=False)
    print("atom masses m_f(a/q) at X = NMAX, vs predicted mu^2/phi^2 for Lambda:")
    for (a, q) in tests:
        phase = np.exp(2j * np.pi * a * np.arange(NMAX + 1) / q)
        for f, name, axis in [(LamV, "Lambda", ax[0]), (LioV, "Liouville", ax[1])]:
            g = f * phase
            cs = np.cumsum(g)
            m = np.abs(cs[Xs] / Xs) ** 2
            axis.loglog(Xs, m, lw=1.0, label=f"a/q={a}/{q}")
            if f is LamV:
                pred = (mobius(q) / totient(q)) ** 2
                print(f"  a/q={a}/{q}: Lambda {m[-1]:.5f} (pred {float(pred):.5f}),"
                      f"  Liouville {np.abs(np.cumsum(LioV*phase)[Xs][-1]/Xs[-1])**2:.2e}")
    ax[0].set_title(r"$\Lambda$: rational atoms persist at $\mu(q)^2/\varphi(q)^2$")
    ax[1].set_title(r"Liouville $\lambda$: every rational atom dies (Davenport)")
    for axis in ax:
        axis.set_xlabel("X"); axis.legend(fontsize=7)
        axis.set_ylabel("atom mass |(1/X) sum f(n)e(an/q)|^2")
    fig.tight_layout()
    fig.savefig(FIG / "exp10_parity.png", dpi=140)
    print("saved figures/exp10_parity.png")

if __name__ == "__main__":
    main()
