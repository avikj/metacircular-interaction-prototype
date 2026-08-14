"""Exact replay for notes/DIAGONAL_SMITH_CONGRUENCE_TORSOR.md (cf-tessera).

The two-sided stabilizer of a nonzero diagonal Smith endpoint diag(d1, d2)
with m = d2/d1 is the congruence subgroup Gamma_0(m) of GL_2(Z) via
H -> (H, D^-1 H^-1 D); the path fiber of the classical diagonal Smith step
U diag(a,b) V = diag(g, ab/g) is a regular Gamma_0(AB)-torsor; the Bezout
ambiguity (x,y) -> (x+tB, y-tA) is exactly its unipotent subgroup.
All computations are exact integers.
"""

from math import gcd


def mat_mul(p, q):
    return tuple(
        tuple(sum(p[i][k] * q[k][j] for k in range(2)) for j in range(2))
        for i in range(2)
    )


def det2(m):
    return m[0][0] * m[1][1] - m[0][1] * m[1][0]


def inv_unimodular(m):
    d = det2(m)
    assert abs(d) == 1
    return ((m[1][1] * d, -m[0][1] * d), (-m[1][0] * d, m[0][0] * d))


def diag(d1, d2):
    return ((d1, 0), (0, d2))


def in_gamma0(h, m):
    return abs(det2(h)) == 1 and h[1][0] % m == 0


def conjugate_by_diag(h, d1, d2):
    """D^-1 M D for D = diag(d1, d2); exact, asserts integrality."""
    m = d2 // d1
    assert d2 == m * d1
    top = (h[0][0], h[0][1] * m)
    assert h[1][0] % m == 0
    return (top, (h[1][0] // m, h[1][1]))


def stabilizer_pair(h, d1, d2):
    """The pair (H, K) stabilizing diag(d1,d2) two-sidedly, for H in
    Gamma_0(d2/d1)."""
    return (h, conjugate_by_diag(inv_unimodular(h), d1, d2))


def two_sided_stabilizes(h, k, d1, d2):
    d = diag(d1, d2)
    return mat_mul(mat_mul(h, d), k) == d


def bezout(a, b):
    """x, y with x*(a//g) + y*(b//g) = 1."""
    g = gcd(a, b)
    A, B = a // g, b // g
    old_r, r = A, B
    old_x, x = 1, 0
    while r:
        q = old_r // r
        old_r, r = r, old_r - q * r
        old_x, x = x, old_x - q * x
    sign = 1 if old_r > 0 else -1
    xx = old_x * sign
    yy = (sign * old_r - xx * A) // B if B else 0
    return xx, yy


def classical_cell(a, b, t=0):
    """The seed cell with Bezout shift t: returns (U, V, D_target)."""
    g = gcd(a, b)
    A, B = a // g, b // g
    x0, y0 = bezout(a, b)
    x, y = x0 + t * B, y0 - t * A
    assert x * A + y * B == 1
    u = ((x, y), (-B, A))
    v = ((1, -y * B), (1, x * A))
    return u, v, diag(g, (a * b) // g)


def torsor_act(h, u, v, d1, d2):
    """H . (U, V) = (H U, V D^-1 H^-1 D)."""
    k = conjugate_by_diag(inv_unimodular(h), d1, d2)
    return mat_mul(h, u), mat_mul(v, k)
