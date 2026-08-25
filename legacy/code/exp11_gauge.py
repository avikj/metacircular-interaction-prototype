"""Experiment 11: the three levels of the charged (parity) sector, measured.

Level 0/1 (Theorem F + Davenport, "return to equilibrium"): equilibrium
expectation of charged observables is zero, and diagonal sampling converges to
it -- (1/X) sum lambda(n) g(n) -> 0 for every periodic g.

Level 2 (Chowla, "flatness/mixing"): the charged sector should sample like a
Bernoulli process: windowed-sum variance ~ H (window length), i.e. flat
spectrum.  We measure Var(sum_{x<n<=x+H} lambda(n)) / H over many windows and
compare with (a) an actual shuffled control, (b) the same statistic for
Lambda-1, which is NOT flat: its windowed variance carries singular-series /
zero-driven structure ~ H log(X/H) (Goldston-Montgomery regime).
"""
import numpy as np
from pairfield import sieve_lambda
from exp10_parity import sieve_liouville

def main():
    NMAX = 2_000_000
    lio = sieve_liouville(NMAX)
    lam = sieve_lambda(NMAX)

    print("== level 0/1: equilibrium values of charged observables ==")
    n = np.arange(NMAX + 1)
    for q, name in [(3, "e(n/3)"), (4, "e(n/4)"), (12, "1_{n=1 mod 12}")]:
        if q < 12:
            g = np.exp(2j * np.pi * n / q)
            v = np.abs(np.sum(lio * g) / NMAX)
        else:
            g = (n % 12 == 1).astype(float)
            v = np.abs(np.sum(lio * g) / NMAX)
        print(f"  |(1/X) sum lambda(n) {name}| = {v:.2e}   (equilibrium value: 0)")

    print("\n== level 2: windowed variance (flatness proxy) ==")
    rng = np.random.default_rng(7)
    for H in [100, 1000, 10000]:
        starts = rng.integers(NMAX // 4, NMAX - H, 4000)
        cs_l = np.cumsum(lio)
        w_l = cs_l[starts + H] - cs_l[starts]
        ratio_l = w_l.var() / H
        # shuffled control (true Bernoulli with same symbol frequencies)
        sh = lio[NMAX // 4:].copy()
        rng.shuffle(sh)
        cs_s = np.cumsum(sh)
        s2 = rng.integers(0, len(sh) - H, 4000)
        ratio_s = (cs_s[s2 + H] - cs_s[s2]).var() / H
        # Lambda - 1 (psi-normalized): windowed variance / H, carries structure
        cs_L = np.cumsum(lam - 1)
        w_L = cs_L[starts + H] - cs_L[starts]
        ratio_L = w_L.var() / H
        print(f"  H={H:6d}: Var/H  lambda={ratio_l:.3f}   shuffled={ratio_s:.3f}   "
              f"(Lambda-1)={ratio_L:.3f}  [~log(X/H)={np.log(NMAX/H):.1f} scale]")

if __name__ == "__main__":
    main()
