"""RED TEAM independent replication of exp6b (Theorem D verification).

Deliberately different design choices from code/exp6b_sumspectrum.py:
  - primes/Lambda to 3e6 (theirs: 2e6), X-range [4e4, 2.7e6] (theirs [2e4,1.9e6])
  - M = 6000 grid points, not a power of two (theirs 8192)
  - single-zero layer: 50,000 zeros (theirs 30,000)
  - pair model: 1500 zeros per sign (theirs 1200)
  - detrend: degree-7 polynomial in log X (theirs: degree 3)
  - spectral window: Blackman-Harris (theirs: Hann)
  - band [30, 300] with cosine-tapered edges (theirs [25,320] hard cut)
  - line amplitudes via direct windowed projection onto e^{-i f log X}
    (Goertzel-style), not FFT bin readout
Also: independent check of the weight law |W| ~ (gamma+gamma')^{-5/2} and of
the opposite-sign suppression, by direct evaluation of the Gamma weights.
"""
import numpy as np
from scipy.special import loggamma
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "data"

def sieve_lambda(N):
    lam = np.zeros(N + 1)
    isc = np.zeros(N + 1, dtype=bool)
    for p in range(2, N + 1):
        if not isc[p]:
            lp = np.log(p)
            q = p
            while q <= N:
                lam[q] = lp
                q *= p
            isc[p * p:: p] = True
    return lam

def conv_self(a):
    L = 1
    while L < 2 * len(a):
        L *= 2
    fa = np.fft.rfft(a, L)
    return np.fft.irfft(fa * fa, L)[: 2 * len(a) - 1]

def main():
    NMAX = 3_000_000
    gam = np.loadtxt(DATA / "odlyzko_zeros_100k.txt")
    lam = sieve_lambda(NMAX)
    r = conv_self(lam)                       # (Lambda*Lambda)(N)
    k = np.arange(len(r), dtype=float)
    R = np.cumsum(r)
    S = np.cumsum(k * r)

    M = 6000
    logX = np.linspace(np.log(4e4), np.log(2.7e6), M)
    Xs = np.exp(logX)
    Xi = Xs.astype(np.int64)
    # exact: G1(X) = sum_{k<=X} r(k)(X-k) = X*R(floor X) - S(floor X)
    G1 = Xs * R[Xi] - S[Xi]

    # single-zero layer with K1 zeros
    K1 = 50_000
    rho = 0.5 + 1j * gam[:K1]
    c1 = 1.0 / (rho * (rho + 1) * (rho + 2))
    S1 = np.zeros(M)
    for a in range(0, K1, 2500):
        rr, cc = rho[a:a + 2500], c1[a:a + 2500]
        S1 += 2.0 * np.real(np.exp(np.outer(logX, rr + 2.0)) @ cc)

    data = (G1 - Xs ** 3 / 6 + 2 * S1) / Xs ** 2

    # pair model
    K2 = 1500
    sgn = np.concatenate([gam[:K2], -gam[:K2]])
    rr = 0.5 + 1j * sgn
    LG = loggamma(rr)
    W = np.exp(LG[:, None] + LG[None, :] - loggamma(rr[:, None] + rr[None, :] + 2.0))
    E = np.exp(1j * np.outer(sgn, logX))     # (2K2, M)
    WE = W @ E
    model = np.real(np.einsum('ij,ij->j', E, WE))

    # detrend with degree-7 polynomial in logX
    def detrend(y):
        return y - np.polyval(np.polyfit(logX, y, 7), logX)
    d0, m0 = detrend(data), detrend(model)

    # band-pass [30,300] with tapered edges
    dx = logX[1] - logX[0]
    f = np.fft.rfftfreq(M, d=dx) * 2 * np.pi
    def bandpass(y, lo=30.0, hi=300.0, tap=5.0):
        Y = np.fft.rfft(y - y.mean())
        H = np.zeros_like(f)
        H[(f >= lo + tap) & (f <= hi - tap)] = 1.0
        e1 = (f > lo) & (f < lo + tap)
        H[e1] = 0.5 * (1 - np.cos(np.pi * (f[e1] - lo) / tap))
        e2 = (f > hi - tap) & (f < hi)
        H[e2] = 0.5 * (1 + np.cos(np.pi * (f[e2] - (hi - tap)) / tap))
        return np.fft.irfft(Y * H, M)
    bd, bm = bandpass(d0), bandpass(m0)
    core = slice(M // 6, -M // 6)
    corr = np.corrcoef(bd[core], bm[core])[0, 1]
    ratio = np.std(bd[core]) / np.std(bm[core])
    print(f"[replication] band [30,300]: corr = {corr:.5f}, amplitude ratio = {ratio:.4f}")

    # line amplitudes by windowed projection
    win = np.blackman(M)
    def amp(y, fr):
        z = (y - y.mean()) * win
        return abs(np.sum(z * np.exp(-1j * fr * logX)))
    lines = {"2g1": 2 * gam[0], "g1+g2": gam[0] + gam[1],
             "g1+g3": gam[0] + gam[2], "2g2": 2 * gam[1],
             "g2+g3": gam[1] + gam[2]}
    print("[replication] spectral lines (data/model amplitude ratios):")
    for name, fr in lines.items():
        ad, am = amp(d0, fr), amp(m0, fr)
        print(f"  {name:6s} f={fr:8.3f}: ratio = {ad/am:.4f}")
    # control: single-zero frequencies must be ABSENT from the residual
    for name, fr in [("g1", gam[0]), ("g2", gam[1]), ("g3", gam[2])]:
        ad = amp(d0, fr)
        aref = amp(d0, 2 * gam[0])
        print(f"  control single {name} f={fr:7.3f}: amp / amp(2g1) = {ad/aref:.4f} (should be <<1)")

    # weight law: same-sign decay exponent, opposite-sign suppression
    gs = gam[:400]
    rr1 = 0.5 + 1j * gs
    lg1 = loggamma(rr1)
    Wp = np.exp(lg1[:, None] + lg1[None, :]
                - loggamma(rr1[:, None] + rr1[None, :] + 2.0))
    s = gs[:, None] + gs[None, :]
    x, y = np.log(s.ravel()), np.log(np.abs(Wp.ravel()))
    slope = np.polyfit(x, y, 1)[0]
    print(f"[weight law] same-sign fit slope = {slope:.4f} (predicted -2.5)")
    # opposite sign: gamma=+g_a, gamma'=-g_b
    rr2 = 0.5 - 1j * gs
    lg2 = loggamma(rr2)
    Wo = np.exp(lg1[:, None] + lg2[None, :]
                - loggamma(rr1[:, None] + rr2[None, :] + 2.0))
    mn = np.minimum(gs[:, None], gs[None, :])
    mask = np.abs(gs[:, None] - gs[None, :]) > 1.0
    z = np.log(np.abs(Wo[mask])) + np.pi * mn[mask]
    print(f"[weight law] opposite-sign: log|W| + pi*min(g,g') in "
          f"[{z.min():.1f}, {z.max():.1f}] over 400x400 pairs "
          f"(bounded => |W| << e^-pi*min as claimed)")

if __name__ == "__main__":
    main()
