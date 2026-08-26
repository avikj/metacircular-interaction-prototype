"""Red-team replication for notes/CENTERING_ATOMS.md (Theorem 1.1 + Section 2)
and the reconciliation claim XI of collab/messages/0004.

Independent code (no pairfield import). Four checks:

(1) Difference channel, heat weight e^{-t(x+y)}, t=0.01:
    the mass that the CENTERED pushforward D_*[e^{-t(x+y)}(mu-lambda)^{ox2}]
    assigns to a shrinking window (h-eps, h+eps) converges to the UNCENTERED
    atom C_h(t) = sum_{n-m=h} Lambda(m)Lambda(n)e^{-t(m+n)}, with the
    deviation linear in eps (a density, no atom) -- Theorem 1.1 in action.

(2) Sum channel, same statement at the fiber {N}:
    window mass -> e^{-tN} sum_{m+n=N} Lambda(m)Lambda(n).

(3) Wiener-Bohr atoms (interaction with PARITY.md Theorem P / exp10):
    m_f(a/q) = |X^{-1} sum_{n<=X} f(n) e(an/q)|^2 for f = Lambda and
    f = Lambda - 1 (the discrete avatar of one-body centering).
    Centering must kill the atom at 0/1 and leave every primitive atom
    with q >= 2 at mu(q)^2/phi(q)^2. Replicates exp10's table independently.

(4) Boundary numbers quoted in the Section-4 table (fixed-modulus vs
    polynomial-depth regimes): mean of nu_W -> e^gamma*omega(u) at u=2,3
    (BUCHSTAB_WINDOW Sec.3), and c_X = X/Phi(X,sqrt X) vs
    log X - 1 - 1/log X (BUCHSTAB_WINDOW Sec.4).
"""
import numpy as np

GAMMA = 0.5772156649015329


# ---------- independent sieves ----------
def primes_upto(n):
    s = np.ones(n + 1, dtype=bool)
    s[:2] = False
    for p in range(2, int(n ** 0.5) + 1):
        if s[p]:
            s[p * p:: p] = False
    return np.nonzero(s)[0]


def mangoldt(n):
    """Lambda via prime powers directly (different route than pairfield)."""
    L = np.zeros(n + 1)
    for p in primes_upto(n):
        lp = np.log(p)
        pk = p
        while pk <= n:
            L[pk] = lp
            pk *= p
    return L


# ---------- (1)+(2): fiber-window masses of the centered heat field ----------
def heat_terms_difference(L, h, t, eps, xmax):
    """Mass of (h-eps,h+eps) under each of the four tensor terms of
    D_*[e^{-t(x+y)} (mu-lambda)^{ox2}], lambda = 1_{[1,inf)}dx,
    truncated to x,y <= xmax (tail < e^{-t*xmax}, negligible)."""
    n = np.arange(len(L), dtype=float)
    supp = L > 0
    m = n[supp]
    Lm = L[supp]
    # mu(x) x mu(y): atoms at integer differences; eps<1 => only fiber h
    mask = np.zeros(0)
    mumu = 0.0
    idx = np.arange(len(L))
    hi = idx + h
    ok = (hi < len(L))
    mumu = np.sum(L[idx[ok]] * L[hi[ok]] * np.exp(-t * (idx[ok] + hi[ok])))
    # mu(x) x lambda(y): y in (x+h-eps, x+h+eps) cap [1,xmax]
    lo = np.maximum(1.0, m + h - eps)
    hi2 = np.minimum(float(xmax), m + h + eps)
    w = np.clip(hi2 - lo, 0, None)
    mulam = np.sum(Lm * np.exp(-t * m) * (np.exp(-t * lo) - np.exp(-t * hi2)) / t * (w > 0))
    # lambda(x) x mu(y): x in (y-h-eps, y-h+eps) cap [1,xmax]
    lo = np.maximum(1.0, m - h - eps)
    hi2 = np.minimum(float(xmax), m - h + eps)
    w = np.clip(hi2 - lo, 0, None)
    lammu = np.sum(Lm * np.exp(-t * m) * (np.exp(-t * lo) - np.exp(-t * hi2)) / t * (w > 0))
    # lambda x lambda: int_{h'} e^{-t h'} e^{-2t max(1, 1-h')} /(2t) dh' over window
    hp = np.linspace(h - eps, h + eps, 20001)
    x0 = np.maximum(1.0, 1.0 - hp)
    dens = np.exp(-t * hp) * np.exp(-2 * t * x0) / (2 * t)
    lamlam = np.trapezoid(dens, hp)
    return mumu, mulam, lammu, lamlam


def heat_terms_sum(L, N, t, eps, xmax):
    """Same for S(x,y)=x+y at fiber {N}."""
    idx = np.arange(len(L))
    m = idx[L > 0].astype(float)
    Lm = L[L > 0]
    co = idx[(idx >= 1) & (N - idx >= 1) & (N - idx < len(L))]
    mumu = np.sum(L[co] * L[N - co]) * np.exp(-t * N)
    # mu(x) x lambda(y): y in (N-x-eps, N-x+eps) cap [1,xmax]
    lo = np.maximum(1.0, N - m - eps)
    hi2 = np.minimum(float(xmax), N - m + eps)
    w = np.clip(hi2 - lo, 0, None)
    mulam = np.sum(Lm * np.exp(-t * m) * (np.exp(-t * lo) - np.exp(-t * hi2)) / t * (w > 0))
    lammu = mulam  # symmetric
    # lambda x lambda: density (s-2)e^{-ts} for s>=2
    s = np.linspace(N - eps, N + eps, 20001)
    dens = np.clip(s - 2, 0, None) * np.exp(-t * s)
    lamlam = np.trapezoid(dens, s)
    return mumu, mulam, lammu, lamlam


def check_fibers():
    t = 0.01
    xmax = 4000
    L = mangoldt(xmax)
    print("== (1) difference channel, t=0.01 ==")
    for h in (2, 6):
        idx = np.arange(len(L) - h)
        Ch = np.sum(L[idx] * L[idx + h] * np.exp(-t * (2 * idx + h)))
        print(f"  h={h}: exact atom C_h(t) = {Ch:.10f}")
        for eps in (0.5, 0.1, 0.02, 0.004):
            mm, ml, lm, ll = heat_terms_difference(L, h, t, eps, xmax)
            centered = mm - ml - lm + ll
            print(f"    eps={eps:<6} window mass {centered:.10f}   "
                  f"dev {centered - Ch:+.3e}   dev/eps {(centered - Ch) / eps:+.5f}")
    print("== (2) sum channel, t=0.01 ==")
    for N in (100, 1000):
        co = np.arange(1, N)
        atom = np.exp(-t * N) * np.sum(L[co] * L[N - co])
        print(f"  N={N}: exact atom e^-tN*sum = {atom:.10f}")
        for eps in (0.5, 0.1, 0.02, 0.004):
            mm, ml, lm, ll = heat_terms_sum(L, N, t, eps, xmax)
            centered = mm - ml - lm + ll
            print(f"    eps={eps:<6} window mass {centered:.10f}   "
                  f"dev {centered - atom:+.3e}   dev/eps {(centered - atom) / eps:+.5f}")


# ---------- (3): Wiener-Bohr atoms, Lambda vs Lambda-1 ----------
def check_wiener_bohr():
    from math import gcd
    X = 2_000_000
    L = mangoldt(X)
    n = np.arange(X + 1)
    print("== (3) Wiener-Bohr atoms: Lambda vs centered Lambda-1 (X=2e6) ==")

    def mu(q):
        # squarefree Moebius by trial division (q small)
        m, r, qq = 1, q, 2
        while qq * qq <= r:
            if r % qq == 0:
                r //= qq
                if r % qq == 0:
                    return 0
                m = -m
            qq += 1
        if r > 1:
            m = -m
        return m

    def phi(q):
        r, res, p = q, q, 2
        while p * p <= r:
            if r % p == 0:
                res -= res // p
                while r % p == 0:
                    r //= p
            p += 1
        if r > 1:
            res -= res // r
        return res

    print(f"  {'a/q':>5} {'m_Lambda':>10} {'m_(Lambda-1)':>13} {'mu^2/phi^2':>11}")
    for (a, q) in [(1, 1), (1, 2), (1, 3), (1, 4), (1, 6), (2, 5)]:
        ph = np.exp(2j * np.pi * a * n / q)
        mL = abs(np.sum(L * ph) / X) ** 2
        mC = abs(np.sum((L - (n >= 1)) * ph) / X) ** 2
        pred = (mu(q) / phi(q)) ** 2
        print(f"  {a}/{q:<3} {mL:10.5f} {mC:13.5f} {pred:11.5f}")


# ---------- (4): regime-boundary numbers ----------
def check_buchstab_boundary():
    X = 1_000_000
    print("== (4) fixed-modulus vs polynomial-depth boundary (X=1e6) ==")
    pr_all = primes_upto(X)
    for u in (2.0, 3.0):
        w = X ** (1.0 / u)
        pr = pr_all[pr_all <= w]
        WoverPhi = np.prod(pr / (pr - 1.0))
        rough = np.ones(X + 1, dtype=bool)
        rough[0] = False
        for p in pr:
            rough[p::p] = False
        rough_count = rough[1:].sum()
        mean_nu = WoverPhi * rough_count / X
        omega = 1 / u if u <= 2 else (1 + np.log(u - 1)) / u
        print(f"  u={u}: mean nu_W = {mean_nu:.5f}   e^gamma*omega(u) = "
              f"{np.exp(GAMMA) * omega:.5f}")
    # c_X at w = sqrt X
    w = int(X ** 0.5)
    pr = pr_all[pr_all <= w]
    rough = np.ones(X + 1, dtype=bool)
    rough[0] = False
    for p in pr:
        rough[p::p] = False
    Phi = int(rough[1:].sum())
    cX = X / Phi
    lx = np.log(X)
    print(f"  c_X = X/Phi(X,sqrt X) = {cX:.5f}  vs  log X - 1 - 1/log X = "
          f"{lx - 1 - 1 / lx:.5f}   (log X = {lx:.5f})")


if __name__ == "__main__":
    check_fibers()
    check_wiener_bohr()
    check_buchstab_boundary()
