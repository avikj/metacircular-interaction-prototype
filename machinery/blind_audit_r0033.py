"""Blind hostile audit of registry claim R0033 (agent fleet-blind-r0033).

Everything here is derived independently of the owner's packet.  Exact
integer / rational arithmetic only; every finite check is exhaustive.

Independent derivation (written down BEFORE any computation, per protocol)
--------------------------------------------------------------------------
Let D = diag(d1, d2) with d1*d2 != 0 and m = d2/d1 an integer.

(1) Two-sided stabilizer.  Suppose H, K in GL_2(Z) with H D K = D.
    D is invertible over Q, so K is FORCED: K = D^{-1} H^{-1} D over Q.
    Write G = H^{-1}, which is integral because H is unimodular.  Then

        (D^{-1} G D)_{ij} = g_{ij} * d_j / d_i,

    so K11 = g11, K22 = g22 (always integral), K12 = g12 * (d2/d1) = m*g12
    (always integral because m in Z), and K21 = g21 * (d1/d2) = g21 / m.
    Hence K is integral  <=>  m | (H^{-1})_21.

(2) The corner of the inverse, both determinant signs.  For 2x2,
    H^{-1} = det(H)^{-1} * adj(H) = det(H)^{-1} * ((h22, -h12), (-h21, h11)),
    so (H^{-1})_21 = -det(H) * h21.  Since det(H) = +-1 this is +-h21 for
    BOTH signs, and divisibility is sign-blind:
        m | (H^{-1})_21  <=>  m | h21  <=>  |m| divides h21.
    (For negative m, "m divides x" means the same as "|m| divides x".)

(3) det K = det(D^{-1}) det(H^{-1}) det(D) = det(H)^{-1} = +-1, so K is
    automatically unimodular once integral.  Therefore

        {(H,K) in GL_2(Z)^2 : HDK = D}  =  {(H, D^{-1}H^{-1}D) : |m| | H_21},

    i.e. the H-projection is exactly Gamma_0(m) := {M in GL_2(Z) : m|M_21}
    (= Gamma_0(|m|)).  The set of pairs is closed under
    (H1,K1)*(H2,K2) := (H1H2, K2K1) (the GL x GL^op product, the natural
    one for two-sided multiplication) and H -> (H, D^{-1}H^{-1}D) is a
    group isomorphism onto it FOR THAT PRODUCT.  It is NOT closed under
    the plain componentwise product (counterexample in the tests): the
    K-parts of two stabilizer pairs need not commute.

(4) Torsor.  Fix M and a unimodular pair (U0, V0) with U0 M V0 = D.  If
    U M V = D with (U,V) unimodular, put H = U U0^{-1} in GL_2(Z); then
    H D (V0^{-1} V) = D, so by (1) H in Gamma_0(m) and V = V0 D^{-1}H^{-1}D.
    Conversely (HU) M (V D^{-1}H^{-1}D) = H D D^{-1}H^{-1} D = D, and
    H1.(H2.(U,V)) = (H1H2).(U,V), a genuine left action.  Freeness: HU = U
    with U invertible forces H = I.  So the action is free and transitive.

(5) Classical cell.  a, b nonzero integers (ANY signs), g = gcd(|a|,|b|) > 0,
    A = a/g, B = b/g (signs preserved), xA + yB = 1,
    U0 = ((x, y), (-B, A)),  V0 = ((1, -y*B), (1, x*A)).
    Direct multiplication (done symbolically below, verified exhaustively):
        U0 diag(a,b) V0 = diag(g, ab/g),  det U0 = det V0 = xA + yB = 1.
    Here d1 = g, d2 = ab/g = g*A*B, so d1 | d2 always (any signs) and the
    level is m = d2/d1 = A*B = ab/g^2, which is NEGATIVE when a, b have
    mixed signs; the stabilizer is then Gamma_0(|AB|) = Gamma_0(AB) under
    the sign-blind reading of divisibility.  Note diag(g, ab/g) has a
    negative second entry when ab < 0: it is the Smith form only up to the
    sign (unit) of the second invariant factor; the identity as stated is
    still literally true.

(6) Bezout shifts.  (x,y) -> (x+tB, y-tA) preserves xA+yB=1 and gives
        U_t = H_t U0,  V_t = V0 D^{-1} H_t^{-1} D,
    with H_t = ((1,-t),(0,1)); D^{-1}H_t^{-1}D = ((1, t*A*B),(0,1)).
    The unipotents {H_t} are a proper subgroup of Gamma_0(AB): e.g.
    diag(1,-1) in Gamma_0(AB) has determinant -1 while every U_t has
    determinant +1, so the fiber point it reaches is reached by no Bezout
    shift; even inside SL_2, ((1,0),(AB,1)) is in Gamma_0(AB) and is not
    any H_t (it changes the second row of U0, which every U_t fixes).

(7) One-sided stabilizers.  HD = D with D invertible forces H = I (over Q,
    hence over Z); same for DK = D.  The two-sided stabilizer always
    contains (-I, -I) and the unipotent pairs from (6), so it is never
    trivial; |m| = 1 (d2 = +-d1) makes it all of GL_2(Z).
"""

from fractions import Fraction
from math import gcd

# ----------------------------------------------------------------------
# exact 2x2 matrix helpers (matrices are 2x2 nested tuples, hashable)
# ----------------------------------------------------------------------

I2 = ((1, 0), (0, 1))


def mmul(X, Y):
    return (
        (X[0][0] * Y[0][0] + X[0][1] * Y[1][0],
         X[0][0] * Y[0][1] + X[0][1] * Y[1][1]),
        (X[1][0] * Y[0][0] + X[1][1] * Y[1][0],
         X[1][0] * Y[0][1] + X[1][1] * Y[1][1]),
    )


def mdet(X):
    return X[0][0] * X[1][1] - X[0][1] * X[1][0]


def madj(X):
    return ((X[1][1], -X[0][1]), (-X[1][0], X[0][0]))


def is_integral(X):
    return all(Fraction(e).denominator == 1 for row in X for e in row)


def to_int(X):
    return tuple(tuple(int(e) for e in row) for row in X)


def is_unimodular(X):
    return is_integral(X) and mdet(X) in (1, -1)


def minv_unimodular(H):
    """Exact inverse of a unimodular integer matrix (integral)."""
    d = mdet(H)
    assert d in (1, -1)
    a = madj(H)
    return ((a[0][0] * d, a[0][1] * d), (a[1][0] * d, a[1][1] * d))


def diag(d1, d2):
    return ((d1, 0), (0, d2))


def conj_by_D(X, d1, d2):
    """D^{-1} X D for D = diag(d1,d2), exact rational entries."""
    return (
        (Fraction(X[0][0]), Fraction(X[0][1]) * d2 / d1),
        (Fraction(X[1][0]) * d1 / d2, Fraction(X[1][1])),
    )


def K_of_H(H, d1, d2):
    """The unique rational K with H D K = D, i.e. D^{-1} H^{-1} D.
    Returns an integer matrix if integral, else None."""
    K = conj_by_D(minv_unimodular(H), d1, d2)
    if is_integral(K):
        return to_int(K)
    return None


def in_gamma0(H, m):
    """H in Gamma_0(m) = {M in GL_2(Z) : m | M_21} (sign-blind: |m|)."""
    return is_unimodular(H) and H[1][0] % abs(m) == 0


def unimodular_window(bound):
    """All H in GL_2(Z) with entries in [-bound, bound], exhaustively."""
    rng = range(-bound, bound + 1)
    out = []
    for a in rng:
        for b in rng:
            for c in rng:
                for d in rng:
                    if a * d - b * c in (1, -1):
                        out.append(((a, b), (c, d)))
    return out


# ----------------------------------------------------------------------
# classical cell (independent construction, any signs of a, b)
# ----------------------------------------------------------------------

def _egcd(p, q):
    """(g, x, y) with x*p + y*q = g = gcd(p,q) >= 0, p,q any integers."""
    old_r, r = p, q
    old_s, s = 1, 0
    old_t, t = 0, 1
    while r != 0:
        quo = old_r // r
        old_r, r = r, old_r - quo * r
        old_s, s = s, old_s - quo * s
        old_t, t = t, old_t - quo * t
    if old_r < 0:
        old_r, old_s, old_t = -old_r, -old_s, -old_t
    return old_r, old_s, old_t


def classical_cell(a, b):
    """For nonzero integers a, b of ANY sign, return
    (g, A, B, x, y, U0, V0, D) with U0 diag(a,b) V0 = D = diag(g, ab/g),
    g = gcd(|a|,|b|) > 0, A = a/g, B = b/g, x*A + y*B = 1,
    U0 = ((x,y),(-B,A)), V0 = ((1,-y*B),(1,x*A))."""
    assert a != 0 and b != 0
    g = gcd(a, b)          # math.gcd: positive
    A, B = a // g, b // g
    gg, x, y = _egcd(A, B)
    assert gg == 1 and x * A + y * B == 1
    U0 = ((x, y), (-B, A))
    V0 = ((1, -y * B), (1, x * A))
    D = diag(g, (a * b) // g)
    return g, A, B, x, y, U0, V0, D


def bezout_shift(a, b, t):
    """The t-th Bezout representative: U_t, V_t built from
    (x+tB, y-tA), plus the claimed H_t = ((1,-t),(0,1))."""
    g, A, B, x, y, _, _, D = classical_cell(a, b)
    xt, yt = x + t * B, y - t * A
    Ut = ((xt, yt), (-B, A))
    Vt = ((1, -yt * B), (1, xt * A))
    Ht = ((1, -t), (0, 1))
    return Ut, Vt, Ht, D


def fiber_action(H, U, V, d1, d2):
    """H.(U,V) = (HU, V D^{-1}H^{-1}D); requires H in Gamma_0(d2/d1)."""
    K = K_of_H(H, d1, d2)
    assert K is not None, "H not in Gamma_0(m): action undefined"
    return mmul(H, U), mmul(V, K)


def fiber_points_in_window(M, D, bound):
    """All unimodular pairs (U,V), U entries in [-bound,bound], with
    U M V = D.  V is forced = M^{-1} U^{-1} D over Q, kept only if it
    is integral and unimodular.  Exact rational arithmetic."""
    detM = mdet(M)
    assert detM != 0
    adjM = madj(M)
    pts = []
    for U in unimodular_window(bound):
        Uinv = minv_unimodular(U)
        # V = M^{-1} U^{-1} D  =  (adjM/detM) Uinv D
        W = mmul(adjM, mmul(Uinv, D))
        V = tuple(tuple(Fraction(e, detM) for e in row) for row in W)
        if is_integral(V):
            V = to_int(V)
            if mdet(V) in (1, -1) and mmul(U, mmul(M, V)) == D:
                pts.append((U, V))
    return pts
