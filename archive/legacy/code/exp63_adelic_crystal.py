#!/usr/bin/env python3
r"""
exp63 -- The adelic duality crystal: Tate's local functional equation as
holonomy, and Freund-Witten as that holonomy cubed.

Lane: Weaver fleet, "adelic crystal".  Executes charter section 8 (duality
crystals) of notes/PYTHAGOREAN_EUCLIDEAN_MACHINE.md in Tate's category, where
the crystal is native.  Deliverable note: notes/ADELIC_CRYSTAL.md.

REGISTERED FORECAST (pre-run, PROTOCOL section 4).  Written before executing:
  F1. The crystal D = Fourier, E = multiplicative inversion J f(x)=|x|^{-1}f(1/x)
      has exactly-involutive E (J^2 = id) and D^2 = parity (not id); on the even
      subspace both are involutions and DE has INFINITE order, so the crystal is
      infinite-dihedral, not Klein-four.
  F2. Both routes around the square are diagonal in the Mellin/quasicharacter
      decomposition, with multipliers gamma_v(chi,s) and gamma_v(chi^-1,1-s);
      their product is chi(-1) (forced by D^2 = parity).  Local holonomy != 1.
  F3. Global holonomy: prod_v gamma_v = 1, equivalent to Lambda(s)=Lambda(1-s).
  F4. B_p(a,b) = prod_{x in {a,b,c}} zeta_p(x)/zeta_p(1-x), a+b+c=1 -- i.e. the
      p-adic Veneziano amplitude is a product of THREE inverse Tate gammas.
      Same closed form at v = infinity with zeta_inf(x) = pi^{-x/2} Gamma(x/2).
  F5. Therefore Freund-Witten (prod over all places = 1) is F3 applied three
      times -- no independent content.
  F6. (The forecast the brief did not ask for, registered anyway:) the truncated
      Freund-Witten product does NOT converge for ANY (a,b).  Reason: absolute
      convergence needs the exponent multisets {a,b,c} and {1-a,1-b,1-c} to
      coincide, impossible since they sum to 1 and 2.
  F7. Controls: a wrong additive normalisation vol(Z_p) = (1-1/p)^{-1} breaks the
      product formula only LOGARITHMICALLY (invisible place by place); a planted
      gamma perturbation gamma_p -> gamma_p (1+p^{-2}) is o(1) locally but gives
      global holonomy zeta(2)/zeta(4) = 1.5198... != 1.

All outputs are printed; nothing is asserted here that the script does not show.
Pramana labels: pratyaksa = printed numbers; anumana = proofs in the note;
sabda = literature, all FETCHED this session (URLs in the note).

Runtime: ~30 s.  Deps: mpmath, sympy, numpy, matplotlib.
"""

import cmath
import math
from fractions import Fraction

import mpmath as mp
import numpy as np
import sympy as sp

mp.mp.dps = 40

BANNER = "=" * 78
def head(t):
    print("\n" + BANNER + "\n" + t + "\n" + BANNER)


# ----------------------------------------------------------------------------
# Local factors (Tate).  zeta_v is the LOCAL ZETA FACTOR, gamma_v the local
# gamma factor of the functional equation:  gamma_v(s) = zeta_v(1-s)/zeta_v(s)
# for the trivial character.
# ----------------------------------------------------------------------------

def zeta_p(p, x):
    return 1 / (1 - mp.mpf(p) ** (-x))

def zeta_inf(x):
    return mp.pi ** (-x / 2) * mp.gamma(x / 2)

def gamma_p(p, s):
    return zeta_p(p, 1 - s) / zeta_p(p, s)

def gamma_inf(s):
    return zeta_inf(1 - s) / zeta_inf(s)


# ----------------------------------------------------------------------------
# 1. THE FOUR CORNERS AT v = infinity
#    D = Fourier (psi(x) = e^{2 pi i x}, Lebesgue measure -- self-dual)
#    E = J,  (J f)(x) = |x|^{-1} f(1/x)      [implements s -> 1-s, chi -> chi^-1]
#    Z(f, chi, s) = int f(x) chi(x) |x|^s d^x x,   d^x x = dx/|x|.
# ----------------------------------------------------------------------------

def Z_inf(f, s, sign=+1, lim=mp.inf):
    """Z(f, chi, s) with chi = trivial (sign=+1) or sgn (sign=-1)."""
    def g(x):
        if x == 0:
            return mp.mpf(0)
        chi = 1 if (sign == +1 or x > 0) else -1
        return f(x) * chi * abs(x) ** (s - 1)
    return mp.quad(g, [-lim, -1, 0, 1, lim])

def fourier_inf(f, y, lim=12):
    return mp.quad(lambda x: f(x) * mp.e ** (2j * mp.pi * x * y), [-lim, 0, lim])


def section1_archimedean():
    head("1. ARCHIMEDEAN CORNER: Gaussian, Gamma-factor, gamma_infinity")

    gauss = lambda x: mp.e ** (-mp.pi * x ** 2)

    # (i) D-fixed point: the Gaussian is its own Fourier transform.
    err = max(abs(fourier_inf(gauss, y) - gauss(y)) for y in [0, 0.3, 1.0, 2.5])
    print(f"  D-fixed point at infinity: max |F[e^{{-pi x^2}}] - e^{{-pi y^2}}| = {mp.nstr(err,3)}")

    # (ii) local zeta integral -> pi^{-s/2} Gamma(s/2)
    for s in [mp.mpf('0.7'), mp.mpf('1.5'), mp.mpf('0.5') + 3j]:
        num = Z_inf(gauss, s, +1, lim=14)
        ex = zeta_inf(s)
        print(f"  Z_inf(gauss,1,s={mp.nstr(s,6)}) = {mp.nstr(num,12)}   "
              f"pi^-s/2 Gamma(s/2) = {mp.nstr(ex,12)}   rel.err {mp.nstr(abs(num-ex)/abs(ex),3)}")

    # (iii) gamma_infinity is INDEPENDENT of the test function -- the real
    #       content of the local functional equation.  Three test functions,
    #       two of them NOT self-dual.
    head("1b. gamma_infinity is test-function-independent (the local FE)")
    tests = {
        "gaussian e^{-pi x^2}": (gauss, lambda y: gauss(y)),
        "x^2 e^{-pi x^2}":      (lambda x: x**2 * gauss(x),
                                 lambda y: (1/(2*mp.pi) - y**2) * gauss(y)),
        "e^{-pi(x-1)^2}":       (lambda x: mp.e ** (-mp.pi * (x - 1) ** 2),
                                 lambda y: gauss(y) * mp.e ** (2j * mp.pi * y)),
    }
    s = mp.mpf('0.6')
    print(f"  s = {s};   gamma_inf(s) = zeta_inf(1-s)/zeta_inf(s) = {mp.nstr(gamma_inf(s),14)}")
    for name, (f, fh) in tests.items():
        # verify the analytic fhat against numerical Fourier first
        fe = max(abs(fourier_inf(f, y) - fh(y)) for y in [0.2, 1.1])
        num = Z_inf(fh, 1 - s, +1, lim=14)
        den = Z_inf(f, s, +1, lim=14)
        ratio = num / den
        print(f"    f = {name:22s}  |F f - fhat|<{mp.nstr(fe,2)}   "
              f"Z(fhat,1-s)/Z(f,s) = {mp.nstr(ratio,14)}   "
              f"dev {mp.nstr(abs(ratio-gamma_inf(s)),3)}")

    # (iv) odd sector: chi = sgn, f = x e^{-pi x^2} is an F-eigenfunction, eigenvalue i.
    fodd = lambda x: x * gauss(x)
    e_num = fourier_inf(fodd, mp.mpf('0.7')) / (1j * fodd(mp.mpf('0.7')))
    print(f"  odd sector: F[x e^{{-pi x^2}}] = i * (same);  measured eigenvalue/i = {mp.nstr(e_num,10)}")
    zi_odd = lambda x: mp.pi ** (-(x + 1) / 2) * mp.gamma((x + 1) / 2)
    g_odd = 1j * zi_odd(1 - s) / zi_odd(s)
    num = Z_inf(lambda y: 1j * fodd(y), 1 - s, -1, lim=14)
    den = Z_inf(fodd, s, -1, lim=14)
    print(f"  gamma_inf(sgn,s) predicted = i*zeta_inf^-(1-s)/zeta_inf^-(s) = {mp.nstr(g_odd,12)}")
    print(f"                     measured = {mp.nstr(num/den,12)}    "
          f"dev {mp.nstr(abs(num/den-g_odd),3)}")

    # (v) HOLONOMY IDENTITY  gamma(chi,s) gamma(chi^-1,1-s) = chi(-1),
    #     forced by D^2 = parity.  Trivial chi: chi(-1)=+1.  sgn: chi(-1)=-1.
    head("1c. Local holonomy identity gamma(chi,s)*gamma(chi^-1,1-s) = chi(-1)")
    for s in [mp.mpf('0.6'), mp.mpf('0.5') + 7j, mp.mpf('1.3') - 2j]:
        prod_triv = gamma_inf(s) * gamma_inf(1 - s)
        go = lambda t: 1j * zi_odd(1 - t) / zi_odd(t)
        prod_sgn = go(s) * go(1 - s)
        print(f"  s={mp.nstr(s,6):>18s}   trivial: {mp.nstr(prod_triv,14)}   "
              f"sgn: {mp.nstr(prod_sgn,14)}   (targets +1, -1)")

    # (vi) E-fixed points at infinity: J f = f.
    head("1d. E-fixed points (J f = f) and the empty intersection D-fix ^ E-fix")
    jf = lambda x: abs(x) ** mp.mpf('0.5') / (1 + x ** 2)
    err = max(abs((1 / abs(x)) * jf(1 / x) - jf(x)) for x in [0.3, 1.0, 2.0, 7.0])
    print(f"  J-fixed:  f(x) = |x|^{{1/2}}/(1+x^2):  max |J f - f| = {mp.nstr(err,3)}")
    print("  J^2 = id exactly (one line, see note);  F^2 = parity, F^4 = id.")
    print("  D-fix ^ E-fix = {0}: if Ff=f and Jf=f then Z(f,chi,s)=gamma(chi,s)Z(f,chi,s)")
    print("  for all s, and gamma is nonconstant in s, so Z == 0, so f = 0 (Mellin inversion).")
    return


# ----------------------------------------------------------------------------
# 2. THE FOUR CORNERS AT v = p.  Exact finite model of Q_p:
#    Q_p is approximated by  p^{-M} Z_p / p^N Z_p  ~  Z/p^{M+N},
#    x = u / p^M, each point carrying additive measure p^{-N}.
#    All Bruhat-Schwartz integrands below are locally constant at level p^{-N},
#    so the lattice sums are EXACT on the represented region; the omitted
#    regions are summed analytically.
# ----------------------------------------------------------------------------

def vp(n, p):
    if n == 0:
        return math.inf
    k = 0
    while n % p == 0:
        n //= p
        k += 1
    return k

def frac_part_p(num, den_pow, p):
    """{ num / p^den_pow }_p  as a rational in [0,1): the p-adic principal part."""
    if den_pow <= 0:
        return Fraction(0)
    m = p ** den_pow
    return Fraction(num % m, m)

def psi_p(x: Fraction, p):
    """Standard additive character of Q_p: psi(x) = exp(2 pi i {x}_p),
    kernel exactly Z_p (conductor 0)."""
    den = x.denominator
    k = 0
    while den % p == 0:
        den //= p
        k += 1
    assert den == 1, "argument must have p-power denominator"
    fp = frac_part_p(x.numerator * pow(den, -1, p ** k) if k else 0, k, p) if k else Fraction(0)
    return cmath.exp(2j * math.pi * float(fp))

def abs_p(x: Fraction, p):
    if x == 0:
        return 0.0
    return float(p) ** (vp(x.denominator, p) - vp(x.numerator, p))


def section2_padic(p=3, M=2, N=3):
    head(f"2. FINITE PLACE p={p}: exact lattice model of Q_p (M={M}, N={N})")

    # (i) D-fixed point: 1_{Z_p} is its own Fourier transform (self-dual measure
    #     vol(Z_p)=1, character psi_p of conductor Z_p).
    xs_Zp = [Fraction(u, 1) for u in range(p ** N)]          # Z_p at level p^-N
    ys = [Fraction(w, p ** M) for w in range(p ** (M + N))]  # p^-M Z_p at level p^-N
    worst = 0.0
    for y in ys[: min(len(ys), 400)]:
        fh = sum(psi_p(x * y, p) for x in xs_Zp) * p ** (-N)
        target = 1.0 if abs_p(y, p) <= 1 else 0.0
        worst = max(worst, abs(fh - target))
    print(f"  D-fixed point at p: max_y |hat(1_Zp)(y) - 1_Zp(y)| = {worst:.3e}")

    # (ii) Z_p(1_{Z_p}, chi_unram, s) = 1/(1 - chi(p) p^{-s}) with
    #      d^x x normalised so that vol^x(Z_p^*) = 1.
    for s in [mp.mpf('0.8'), mp.mpf('0.5') + 4j]:
        direct = mp.nsum(lambda n: mp.mpf(p) ** (-n * s), [0, mp.inf])
        print(f"  Z_p(1_Zp, 1, s={mp.nstr(s,6)}) shellsum = {mp.nstr(direct,14)}   "
              f"(1-p^-s)^-1 = {mp.nstr(zeta_p(p,s),14)}")

    # (iii) gamma_p test-function independence: several Bruhat-Schwartz f.
    head(f"2b. gamma_p is test-function-independent (local FE at p={p})")
    s = mp.mpf('0.6')
    def lattice_fourier(fvals, xs, y):
        return sum(fv * psi_p(x * y, p) for fv, x in zip(fvals, xs)) * p ** (-N)

    xs_all = [Fraction(u, p ** M) for u in range(p ** (M + N))]
    def zeta_integral(fun, s):
        """int f(x) |x|^{s-1} dx over p^-M Z_p, exact for f locally const at p^-N,
        f supported in p^-M Z_p, using d^x x = dx/((1-1/p)|x|).
        Returns Z(f,1,s) = int f |x|^s d^x x."""
        tot = mp.mpc(0)
        for x in xs_all:
            if x == 0:
                continue
            fv = fun(x)
            if fv == 0:
                continue
            tot += mp.mpc(fv) * mp.mpf(abs_p(x, p)) ** (s - 1) * mp.mpf(p) ** (-N)
        # analytic tail: the ball p^N Z_p around 0 (f is constant = f(0) there)
        f0 = fun(Fraction(0))
        if f0 != 0:
            tot += mp.mpc(f0) * (1 - mp.mpf(1) / p) * mp.mpf(p) ** (-N * s) / (1 - mp.mpf(p) ** (-s))
        return tot / (1 - mp.mpf(1) / p)

    def indicator(cond):
        return lambda x: 1.0 if cond(x) else 0.0

    tf = {
        "1_{Z_p}":        indicator(lambda x: abs_p(x, p) <= 1),
        "1_{1+pZ_p}":     indicator(lambda x: abs_p(x - 1, p) <= 1.0 / p),
        "1_{p^-1 Z_p}":   indicator(lambda x: abs_p(x, p) <= p),
        "1_{Z_p^*}":      indicator(lambda x: abs_p(x, p) == 1.0),
    }
    print(f"  s = {s};   gamma_p(s) = (1-p^-s)/(1-p^{{s-1}}) = {mp.nstr(gamma_p(p,s),14)}")
    for name, f in tf.items():
        fvals = [f(x) for x in xs_all]
        fh = {y: lattice_fourier(fvals, xs_all, y) for y in xs_all}
        fhfun = lambda x: fh[x]
        num = zeta_integral(fhfun, 1 - s)
        den = zeta_integral(f, s)
        ratio = num / den
        print(f"    f = {name:16s} Z(fhat,1-s)/Z(f,s) = {mp.nstr(ratio,14)}   "
              f"dev {mp.nstr(abs(ratio - gamma_p(p, s)), 3)}")

    # (iv) local holonomy identity at p
    head(f"2c. Local holonomy at p={p}:  gamma_p(s) gamma_p(1-s) = 1 = chi(-1)")
    for s in [mp.mpf('0.6'), mp.mpf('0.5') + 7j]:
        print(f"  s={mp.nstr(s,6):>18s}  gamma_p(s)*gamma_p(1-s) = "
              f"{mp.nstr(gamma_p(p,s)*gamma_p(p,1-s),16)}")

    # (v) F^2 = parity at p
    fvals = [tf["1_{1+pZ_p}"](x) for x in xs_all]
    fh = {y: lattice_fourier(fvals, xs_all, y) for y in xs_all}
    fhh = {y: sum(fh[x] * psi_p(x * y, p) for x in xs_all) * p ** (-N) for y in xs_all[:200]}
    worst = max(abs(fhh[y] - tf["1_{1+pZ_p}"](-y)) for y in xs_all[:200])
    print(f"  D^2 = parity at p:  max |F^2 f (y) - f(-y)| = {worst:.3e}   "
          "(NOT f(y): F is order 4, not 2)")


# ----------------------------------------------------------------------------
# 3. GLOBAL HOLONOMY: prod_v gamma_v(s) = 1.
# ----------------------------------------------------------------------------

def section3_global():
    head("3. GLOBAL HOLONOMY  prod_v gamma_v(s) = 1   <=>   Lambda(s) = Lambda(1-s)")
    print("  gamma_inf(s) * prod_p gamma_p(s) = [zeta_inf(1-s)/zeta_inf(s)] * [zeta(1-s)/zeta(s)]^{-1}")
    print("  (the p-product is the ANALYTICALLY CONTINUED Euler product; see control C0)")
    Lam = lambda s: zeta_inf(s) * mp.zeta(s)
    for s in [mp.mpf('0.6'), mp.mpf('2.3'), mp.mpf('0.5') + 14.134725j, mp.mpf('0.3') - 5j]:
        hol = gamma_inf(s) * (mp.zeta(1 - s) / mp.zeta(s))
        print(f"  s = {mp.nstr(s,10):>22s}   prod_v gamma_v(s) = {mp.nstr(hol, 22)}   "
              f"|.-1| = {mp.nstr(abs(hol-1),3)}")
        assert abs(hol - 1) < mp.mpf(10) ** (-25)

    # ---- a genuinely FINITE, convergent instance of the global holonomy:
    #      Dirichlet characters, where eps_v = 1 at every unramified place.
    head("3b. Finite convergent instance: root numbers.  prod_v eps_v = tau(chi)/(i^delta sqrt m)")
    def dirichlet_chars(m):
        """All Dirichlet characters mod m, as dicts a -> value.  Built from an
        INTERNAL DIRECT PRODUCT basis of (Z/m)^*: a generator g is admitted only
        if |<H,g>| = |H| * ord(g), which makes the exponent vectors unique."""
        import itertools
        G = [a for a in range(1, m) if math.gcd(a, m) == 1]
        n = len(G)

        def order(g):
            o, x = 1, g
            while x != 1:
                x = x * g % m
                o += 1
            return o

        def span(gens_):
            S = {1}
            for g in gens_:
                S = {s * pow(g, e, m) % m for s in S for e in range(order(g))}
            return S

        gens, gen_ord = [], []
        for g in G:
            if len(span(gens)) == n:
                break
            og = order(g)
            if len(span(gens + [g])) == len(span(gens)) * og:
                gens.append(g)
                gen_ord.append(og)
        assert len(span(gens)) == n, (m, gens)

        chars = []
        for expo in itertools.product(*[range(o) for o in gen_ord]):
            table = {}
            for idx in itertools.product(*[range(o) for o in gen_ord]):
                el, val = 1, 0.0
                for g, e, k, o in zip(gens, idx, expo, gen_ord):
                    el = el * pow(g, e, m) % m
                    val += e * k / o
                table[el] = cmath.exp(2j * math.pi * val)
            assert len(table) == n
            chars.append(table)
        return chars

    def is_primitive(chi, m):
        for d in sp.divisors(m)[:-1]:
            if all(abs(chi[a] - 1) < 1e-9 for a in chi if (a - 1) % d == 0):
                return False
        return True

    def L_dirichlet(s, chi, m):
        return mp.mpf(m) ** (-s) * sum(mp.mpc(chi[a]) * mp.zeta(s, mp.mpf(a) / m)
                                       for a in chi)

    print("  (eps_v = 1 at every unramified place, so this global product is FINITE:")
    print("   a fully convergent instance of the holonomy theorem.)")
    s = mp.mpf('0.63') + 2j
    for m in [4, 5, 7, 8, 12, 13]:
        for chi in dirichlet_chars(m):
            if not is_primitive(chi, m) or all(abs(v - 1) < 1e-9 for v in chi.values()):
                continue
            tau = sum(mp.mpc(chi[a]) * mp.e ** (2j * mp.pi * a / m) for a in chi)
            delta = 1 if abs(chi[m - 1] + 1) < 1e-9 else 0
            eps = tau / (1j ** delta * mp.sqrt(m))
            chib = {a: v.conjugate() for a, v in chi.items()}
            Lam = lambda t, c: (mp.mpf(m) / mp.pi) ** ((t + delta) / 2) * \
                mp.gamma((t + delta) / 2) * L_dirichlet(t, c, m)
            lhs, rhs = Lam(1 - s, chib), eps ** (-1) * Lam(s, chi)
            ordr = max(1, min(k for k in range(1, m + 1)
                              if all(abs(v ** k - 1) < 1e-8 for v in chi.values())))
            print(f"  m={m:2d} ord={ordr} delta={delta}  |tau|/sqrt(m)={mp.nstr(abs(tau)/mp.sqrt(m),8)}"
                  f"  eps={mp.nstr(eps,8):>24s} |eps|={mp.nstr(abs(eps),6)}"
                  f"  FE residual = {mp.nstr(abs(lhs-rhs)/abs(rhs),3)}")


# ----------------------------------------------------------------------------
# 4. FREUND-WITTEN.  B_v(a,b) = int_{Q_v} |x|^{a-1} |1-x|^{b-1} dx,  a+b+c=1.
# ----------------------------------------------------------------------------

def B_p_closed(p, a, b):
    c = 1 - a - b
    out = mp.mpf(1)
    for x in (a, b, c):
        out *= zeta_p(p, x) / zeta_p(p, 1 - x)
    return out

def B_inf_closed(a, b):
    c = 1 - a - b
    out = mp.sqrt(mp.pi)
    for x in (a, b, c):
        out *= mp.gamma(x / 2) / mp.gamma((1 - x) / 2)
    return out

def B_inf_sum_of_betas(a, b):
    c = 1 - a - b
    return (mp.gamma(a) * mp.gamma(b) / mp.gamma(1 - c)
            + mp.gamma(b) * mp.gamma(c) / mp.gamma(1 - a)
            + mp.gamma(c) * mp.gamma(a) / mp.gamma(1 - b))


def B_p_direct(p, a, b, M=3, N=5):
    """Direct integration of |x|^{a-1}|1-x|^{b-1} over Q_p on the exact lattice
    p^-M Z_p / p^N Z_p, with the three omitted regions summed in closed form.
    Independent of the closed form -- this is the falsifier for the derivation."""
    tot = mp.mpc(0)
    pm = p ** M
    for u in range(p ** (M + N)):
        if u == 0 or u == pm:
            continue                      # the two balls handled analytically
        ax = mp.mpf(p) ** (M - vp(u, p))
        d = pm - u
        a1x = mp.mpf(p) ** (M - vp(d, p))
        tot += ax ** (a - 1) * a1x ** (b - 1) * mp.mpf(p) ** (-N)
    onemp = 1 - mp.mpf(1) / p
    tot += onemp * mp.mpf(p) ** (-N * a) / (1 - mp.mpf(p) ** (-a))      # p^N Z_p
    tot += onemp * mp.mpf(p) ** (-N * b) / (1 - mp.mpf(p) ** (-b))      # 1+p^N Z_p
    c = 1 - a - b
    tot += onemp * mp.mpf(p) ** (-(M + 1) * c) / (1 - mp.mpf(p) ** (-c))  # |x| > p^M
    return tot


def B_inf_direct(a, b):
    f = lambda x: abs(x) ** (a - 1) * abs(1 - x) ** (b - 1)
    return (mp.quad(f, [-mp.inf, -1, 0]) + mp.quad(f, [0, mp.mpf('0.5'), 1])
            + mp.quad(f, [1, 2, mp.inf]))


def section4_freund_witten():
    head("4. FREUND-WITTEN: local Beta functions, derived and verified")
    print("  Derivation (see note section 4): partition Q_p into the four balls")
    print("    |x|<1 ; |1-x|<1 ; |x|=|1-x|=1 ; |x|>1 ,  giving")
    print("    B_p = (1-1/p)[1/(p^a-1)+1/(p^b-1)+1/(p^c-1)] + 1 - 2/p ,  c = 1-a-b,")
    print("  which collapses (exact algebra, checked symbolically below) to")
    print("    B_p(a,b) = prod_{x in {a,b,c}} zeta_p(x)/zeta_p(1-x) = prod_x gamma_p(x)^{-1}.")

    # symbolic collapse
    u, v, w, q = sp.symbols('u v w q', positive=True)
    lhs = (1 - q) * (u / (1 - u) + v / (1 - v) + w / (1 - w)) + 1 - 2 * q
    rhs = (1 - v * w) * (1 - u * w) * (1 - u * v) / ((1 - u) * (1 - v) * (1 - w))
    diff = sp.simplify((lhs - rhs).subs(q, u * v * w))
    print(f"  SYMBOLIC: simplify(shell-sum - product form) with q = uvw  ->  {diff}")

    # direct lattice integration vs closed form
    head("4b. B_p: direct p-adic lattice integration vs closed form")
    for p in [2, 3, 5]:
        for (a, b) in [(mp.mpf('0.3'), mp.mpf('0.4')),
                       (mp.mpf('0.25') + 0.3j, mp.mpf('0.35') - 0.1j)]:
            d = B_p_direct(p, a, b, M=3, N=(5 if p < 5 else 4))
            cf = B_p_closed(p, a, b)
            print(f"  p={p}  (a,b)=({mp.nstr(a,5)},{mp.nstr(b,5)})  direct={mp.nstr(d,14)}  "
                  f"closed={mp.nstr(cf,14)}  rel={mp.nstr(abs(d-cf)/abs(cf),3)}")

    head("4c. B_infinity: three Beta pieces, Gamma-triple form, and gamma_inf form")
    for (a, b) in [(mp.mpf('0.3'), mp.mpf('0.4')), (mp.mpf('0.2'), mp.mpf('0.5')),
                   (mp.mpf('0.25') + 0.2j, mp.mpf('0.3') - 0.15j)]:
        d = B_inf_direct(a, b)
        s3 = B_inf_sum_of_betas(a, b)
        cf = B_inf_closed(a, b)
        print(f"  (a,b)=({mp.nstr(a,5)},{mp.nstr(b,5)})  quad={mp.nstr(d,12)}  "
              f"3-Beta={mp.nstr(s3,12)}  gamma_inf-form={mp.nstr(cf,12)}")
        print(f"        rel(quad,3Beta)={mp.nstr(abs(d-s3)/abs(s3),3)}   "
              f"rel(3Beta,gamma-form)={mp.nstr(abs(s3-cf)/abs(cf),3)}")

    head("4d. THE PRODUCT FORMULA, in its exact (regularised) form")
    print("  prod_p B_p = prod_x zeta(x)/zeta(1-x) = prod_x gamma_inf(x) = B_inf^{-1}")
    print("  so  B_inf * prod_p B_p = 1  is EXACTLY  prod_v gamma_v(x) = 1, three times.")
    rows = []
    for (a, b) in [(mp.mpf('0.3'), mp.mpf('0.4')), (mp.mpf('1')/3, mp.mpf('1')/3),
                   (mp.mpf('0.15'), mp.mpf('0.7')), (mp.mpf('0.25') + 0.4j, mp.mpf('0.3') - 0.2j),
                   (mp.mpf('-1.4'), mp.mpf('0.9'))]:
        c = 1 - a - b
        reg = mp.mpf(1)
        for x in (a, b, c):
            reg *= mp.zeta(x) / mp.zeta(1 - x)
        val = B_inf_closed(a, b) * reg
        rows.append((a, b, val))
        print(f"  (a,b)=({mp.nstr(a,7)},{mp.nstr(b,7)})  c={mp.nstr(c,7)}   "
              f"B_inf * prod_p B_p = {mp.nstr(val, 25)}   |.-1| = {mp.nstr(abs(val-1),3)}")
    return rows


# ----------------------------------------------------------------------------
# 5. CONTROL LEDGER (designed annihilation, msg 0073)
# ----------------------------------------------------------------------------

def primes_upto(n):
    s = np.ones(n + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(n ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.nonzero(s)[0]


def section5_controls():
    head("5. CONTROL LEDGER (designed annihilation)")

    P = primes_upto(10 ** 6)

    # ---- C0: the truncated product does NOT converge, for ANY (a,b).
    print("  C0  NON-CONVERGENCE (registered forecast F6).")
    print("      prod_p B_p converges absolutely iff sum_p |1-B_p| < inf, which needs")
    print("      Re(x)>1 AND Re(1-x)>1 for every x in {a,b,c}: impossible.  Sharper:")
    print("      the exponent multisets {a,b,c} and {1-a,1-b,1-c} sum to 1 and 2, so")
    print("      they NEVER coincide; no cancellation is available.  Numerically:")
    a = mp.mpf(1) / 3
    b = mp.mpf(1) / 3
    c = 1 - a - b
    Binf = B_inf_closed(a, b)
    print(f"      (a,b,c)=(1/3,1/3,1/3), B_inf = {mp.nstr(Binf,12)}")
    logacc = mp.mpf(0)
    idx = 0
    marks = [10, 100, 1000, 10 ** 4, 10 ** 5, 10 ** 6]
    trunc = {}
    for Pmax in marks:
        while idx < len(P) and P[idx] <= Pmax:
            p = int(P[idx])
            logacc += mp.log(B_p_closed(p, a, b))
            idx += 1
        trunc[Pmax] = mp.log(Binf) + logacc
        # Mertens-level prediction: 3 * sum_{p<=P} (p^{-1/3} - p^{-2/3}) + O(1)
        pr = 3 * sum(mp.mpf(int(q)) ** (-a) - mp.mpf(int(q)) ** (a - 1)
                     for q in P[P <= Pmax])
        print(f"      P={Pmax:>8d}   log(B_inf prod_{{p<=P}} B_p) = {mp.nstr(trunc[Pmax],10):>16s}"
              f"   leading prediction 3*sum(p^-a - p^{{a-1}}) = {mp.nstr(pr,10):>16s}"
              f"   ratio = {mp.nstr(trunc[Pmax]/pr,8)}")
    print("      => the naive adelic product DIVERGES; the Freund-Witten identity is a")
    print("         statement about analytically continued zeta ratios, not a limit.")
    print("         [FETCHED confirmation: Jepsen arXiv:2211.01611, 'there is no kinematic")
    print("          regime for which the product ... converges'.]")

    # ---- C1: wrong additive normalisation of Haar measure at p.
    print("\n  C1  WRONG ADDITIVE NORMALISATION vol(Z_p) = (1-1/p)^{-1} (a realistic slip:")
    print("      using the multiplicatively-normalised measure additively).")
    print("      Then B_p^wrong = B_p/(1-1/p) and the exact identity acquires prod_p (1-1/p)^{-1}.")
    for Pmax in [10, 10 ** 3, 10 ** 5, 10 ** 6]:
        fac = mp.mpf(1)
        for q in P[P <= Pmax]:
            fac /= (1 - mp.mpf(1) / int(q))
        print(f"      P={Pmax:>8d}   broken global holonomy = {mp.nstr(fac,10):>14s}"
              f"   (correct value 1; grows like e^gamma log P = "
              f"{mp.nstr(mp.e**mp.euler*mp.log(Pmax),8)})")
    print("      Diagnosis: the break is INVISIBLE place by place (factor 1+1/p+... -> 1)")
    print("      and only the global product detects it.  This is the whole point of the")
    print("      product formula: it has infinite discriminating power against o(1) errors.")

    # ---- C2: wrong additive character (conductor p^-1 instead of Z_p).
    print("\n  C2  WRONG ADDITIVE CHARACTER psi'_p(x) = psi_p(x/p) (conductor p^{-1}Z_p).")
    print("      Then hat(1_Zp) = 1_{pZ_p} (NOT self-dual), and gamma'_p(s) = p^{s-1} gamma_p(s).")
    s = mp.mpf('0.6')
    for Pmax in [10, 100, 1000]:
        fac = mp.mpf(1)
        for q in P[P <= Pmax]:
            fac *= mp.mpf(int(q)) ** (s - 1)
        print(f"      P={Pmax:>6d}   prod_{{p<=P}} gamma'_p / gamma_p = {mp.nstr(fac,10)}"
              f"   -> 0 (correct value 1)")
    # show the Fourier break explicitly
    xs = [Fraction(u, 1) for u in range(3 ** 3)]
    fh_wrong = [sum(psi_p(x * Fraction(w, 3) / 3, 3) for x in xs) * 3 ** (-3)
                for w in range(9)]
    print(f"      explicit: with psi'_3, hat(1_Z3)(y) for y=w/3, w=0..8:  "
          f"{[round(abs(z),4) for z in fh_wrong]}  (should be all 1 if self-dual)")

    # ---- C3: planted-false gamma factor, locally o(1) but globally fatal.
    print("\n  C3  PLANTED-FALSE GAMMA gamma~_p(s) = gamma_p(s) * (1 + p^{-2}).")
    print("      Local check: the perturbation is 1+p^{-2} -> 1, so any local test with")
    print("      tolerance >= p^{-2} PASSES; but the global holonomy becomes")
    val = mp.zeta(2) / mp.zeta(4)
    print(f"        prod_p (1+p^{{-2}}) = zeta(2)/zeta(4) = {mp.nstr(val,16)}  != 1.")
    print("      And an exact local test rejects it immediately, at the SAME place p=3")
    print("      where section 2b measured Z(fhat,1-s)/Z(f,s) to <4e-16 for four test functions:")
    for p0 in (3, 7):
        s0 = mp.mpf('0.6')
        tru, fake = gamma_p(p0, s0), gamma_p(p0, s0) * (1 + mp.mpf(p0) ** -2)
        print(f"        p={p0}, s=0.6: true gamma = {mp.nstr(tru,14)}, planted = {mp.nstr(fake,14)}"
              f"   -> rejected at relative size {mp.nstr(abs(fake-tru)/abs(tru),3)}"
              f"  (measurement noise 4e-16)")
    print("      A second planted family, gamma_p*(1+p^{-4}) (even more local-invisible):")
    print(f"        global holonomy = zeta(4)/zeta(8) = {mp.nstr(mp.zeta(4)/mp.zeta(8),16)} != 1.")

    # ---- C4: wrong modulus.
    print("\n  C4  WRONG MODULUS |x| := 2^{-v_p(x)} at every p (base-2 instead of base-p).")
    print("      Then the shell derivation gives B_p^wrong with p replaced by 2 in the")
    print("      exponentials but the measure still base-p; the four-ball partition no")
    print("      longer telescopes.  Concretely the shell sum")
    print("        (1-1/p)[1/(2^a-1)+1/(2^b-1)+1/(2^c-1)] + 1 - 2/p")
    for p in [3, 5, 7]:
        aa, bb = mp.mpf('0.3'), mp.mpf('0.4')
        cc = 1 - aa - bb
        wrong = (1 - mp.mpf(1) / p) * sum(1 / (mp.mpf(2) ** x - 1) for x in (aa, bb, cc)) \
            + 1 - 2 / mp.mpf(p)
        print(f"      p={p}: wrong B_p = {mp.nstr(wrong,12)} vs correct "
              f"{mp.nstr(B_p_closed(p,aa,bb),12)}  -> product formula fails at every place")

    # ---- C5: exact test-function class.
    print("\n  C5  TEST-FUNCTION CLASS where the verification holds:")
    print("      * Tate local FE (sections 1-2): f in the Schwartz-Bruhat space S(Q_v)")
    print("        (v=inf: Schwartz; v=p: locally constant, compact support).  Z_v(f,chi,s)")
    print("        converges for Re(s)>0 and continues meromorphically; the FE is an")
    print("        identity of continuations.  gamma_v is independent of f -- verified for")
    print("        3 archimedean and 4 p-adic test functions above.")
    print("      * Freund-Witten (section 4): the integrand |x|^{a-1}|1-x|^{b-1} is NOT")
    print("        Schwartz-Bruhat (Gel'fand-Graev class).  Absolute convergence of B_v")
    print("        needs Re(a)>0, Re(b)>0, Re(a+b)<1 -- the open triangle.  Outside it,")
    print("        B_v means the meromorphic continuation (the closed forms above).")


# ----------------------------------------------------------------------------
# 6. FIGURE
# ----------------------------------------------------------------------------

def section6_figure():
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    fig, ax = plt.subplots(2, 2, figsize=(13, 9.5))

    # (a) the crystal square
    A = ax[0, 0]
    A.set_xlim(0, 10); A.set_ylim(0, 10); A.axis('off')
    A.text(1.4, 8.4, r"$f$", fontsize=17, ha='center')
    A.text(8.4, 8.4, r"$\mathcal{F}f$", fontsize=17, ha='center')
    A.text(1.4, 2.0, r"$Jf$", fontsize=17, ha='center')
    A.text(8.4, 2.0, r"$\mathcal{F}Jf,\ J\mathcal{F}f$", fontsize=15, ha='center')
    A.annotate("", xy=(7.6, 8.4), xytext=(2.2, 8.4), arrowprops=dict(arrowstyle='->', lw=2))
    A.annotate("", xy=(1.4, 2.8), xytext=(1.4, 7.8), arrowprops=dict(arrowstyle='->', lw=2))
    A.annotate("", xy=(8.4, 2.8), xytext=(8.4, 7.8), arrowprops=dict(arrowstyle='->', lw=2, color='C3'))
    A.annotate("", xy=(6.6, 2.0), xytext=(2.4, 2.0), arrowprops=dict(arrowstyle='->', lw=2, color='C3'))
    A.text(4.9, 8.75, r"$D=\mathcal{F}$", fontsize=13, ha='center')
    A.text(0.55, 5.3, r"$E=J$", fontsize=13, ha='center', rotation=90)
    A.text(9.05, 5.3, r"$E$", fontsize=13, ha='center', rotation=90, color='C3')
    A.text(4.5, 1.45, r"$D$", fontsize=13, ha='center', color='C3')
    A.text(5.0, 5.4, "two routes differ by\n"
                     r"$\gamma_v(\chi,s)$ vs $\gamma_v(\chi^{-1},1-s)$" "\n"
                     r"$\gamma_v(\chi,s)\gamma_v(\chi^{-1},1-s)=\chi(-1)$",
           fontsize=11.5, ha='center', va='center',
           bbox=dict(boxstyle='round', fc='#ffeeba', ec='0.5'))
    A.set_title("(a) the crystal: local holonomy $\\gamma_v \\neq 1$ at every place",
                fontsize=12)

    # (b) pole sets in the complex s-plane: the archimedean place is the odd one out
    B = ax[0, 1]
    for p in [2, 3, 5, 7]:
        per = 2 * math.pi / math.log(p)
        ks = np.arange(-6, 7)
        B.scatter(np.zeros_like(ks, dtype=float), ks * per, s=26,
                  label=f"$\\zeta_p$, $p={p}$", alpha=0.85)
    gk = np.arange(0, 10)
    B.scatter(-2.0 * gk, np.zeros_like(gk, dtype=float), s=70, marker='s',
              color='k', label=r"$\zeta_\infty=\pi^{-s/2}\Gamma(s/2)$")
    B.set_xlim(-19, 4)
    B.set_ylim(-42, 56)
    B.set_xlabel(r"$\mathrm{Re}\,s$")
    B.set_ylabel(r"$\mathrm{Im}\,s$")
    B.axvline(0, color='0.85', lw=0.8)
    B.axhline(0, color='0.85', lw=0.8)
    B.set_title("(b) poles of the local factors $\\zeta_v(s)$: finite places give\n"
                r"periodic lattices $\frac{2\pi i}{\log p}\mathbb{Z}$ on $\mathrm{Re}\,s=0$;"
                "\n$\\zeta_\\infty$ is the only non-rational factor "
                "(poles march down the real axis)", fontsize=10.5)
    B.legend(fontsize=8.5, loc='upper left', ncol=2)
    B.grid(alpha=0.25)

    # (c) divergence of the truncated Freund-Witten product
    C = ax[1, 0]
    P = primes_upto(10 ** 6)
    for (aa, bb, lab) in [(1 / 3, 1 / 3, "a=b=c=1/3"),
                          (0.3, 0.4, "a=.3,b=.4,c=.3"),
                          (0.15, 0.7, "a=.15,b=.7,c=.15")]:
        cc = 1 - aa - bb
        lg = np.zeros(len(P))
        acc = 0.0
        for i, q in enumerate(P):
            q = float(q)
            v = 1.0
            for x in (aa, bb, cc):
                v *= (1 - q ** (x - 1)) / (1 - q ** (-x))
            acc += math.log(v)
            lg[i] = acc
        C.plot(P, lg, lw=1.3, label=lab)
    C.set_xscale('log')
    C.set_xlabel("P")
    C.set_ylabel(r"$\log\left(B_\infty \prod_{p\leq P} B_p\right)$")
    C.set_title("(c) the naive adelic product diverges for every (a,b):\n"
                "the identity lives only after analytic continuation", fontsize=11)
    C.axhline(0, color='k', lw=1, ls='--', label="target (=0)")
    C.legend(fontsize=9)
    C.grid(alpha=0.3)

    # (d) control ledger
    D = ax[1, 1]
    labels = ["correct\n(continued)", "C1 wrong\nHaar, P=1e6", "C3 planted\n$1+p^{-2}$",
              "C3 planted\n$1+p^{-4}$", "C2 wrong\n$\\psi$, P=10"]
    fac = 1.0
    for q in P[P <= 10 ** 6]:
        fac /= (1 - 1.0 / int(q))
    c2 = 1.0
    for q in P[P <= 10]:
        c2 *= float(q) ** (0.6 - 1)
    vals = [1.0, fac, float(mp.zeta(2) / mp.zeta(4)), float(mp.zeta(4) / mp.zeta(8)), c2]
    cols = ['C2'] + ['C3'] * 4
    D.bar(range(len(vals)), vals, color=cols)
    D.set_yscale('log')
    D.axhline(1, color='k', ls='--', lw=1)
    D.set_xticks(range(len(vals)))
    D.set_xticklabels(labels, fontsize=8.5)
    D.set_ylabel("global holonomy $\\prod_v \\gamma_v$")
    D.set_title("(d) control ledger: each wrong convention breaks $\\prod_v\\gamma_v=1$",
                fontsize=11)
    D.set_ylim(0.06, 60)
    for i, v in enumerate(vals):
        D.text(i, v * 1.18, f"{v:.4g}", ha='center', va='bottom', fontsize=8.5)
    D.grid(alpha=0.3, axis='y')

    fig.suptitle("exp63 -- the adelic duality crystal: local holonomy $\\gamma_v\\neq1$, "
                 "global holonomy $\\prod_v\\gamma_v=1$", fontsize=13.5)
    fig.tight_layout(rect=[0, 0, 1, 0.965])
    fig.savefig("figures/exp63_adelic_crystal.png", dpi=140)
    print("\n  figure written: figures/exp63_adelic_crystal.png")


if __name__ == "__main__":
    print(__doc__)
    section1_archimedean()
    section2_padic(p=3, M=2, N=3)
    section3_global()
    section4_freund_witten()
    section5_controls()
    section6_figure()
    head("DONE.  Status: PENDING HOSTILE AUDIT.")
