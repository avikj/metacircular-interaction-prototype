"""Exact replay for notes/RANK_R_PAYLOAD_NORMAL_FORM.md (fleet-payload-nf).

Canonical coordinates (A, B, E, R, S) on the two-sided stabilizer
Stab^2(D) of a normalized rank-r Smith endpoint D = blockdiag(D_r, 0)
(R0037, Theorem 1 of notes/MIXED_RANK_SMITH_STABILIZER.md); the group
law in those coordinates -- the K side composes with the OPPOSITE
convention, since K multiplies events on the right; the payload normal
form of a rank-r normalization event relative to a base event, with
explicit recovery and replay; and the exact transformation law under a
change of base event.  Exact integers and fractions only.
"""

from fractions import Fraction

from flag_congruence_smith_stabilizer import (
    conjugate_by_diag,
    det,
    in_flag_gamma0_congruence,
    inverse_unimodular,
    is_integral,
    to_int,
)
from mixed_rank_smith_stabilizer import blocks, is_zero


# ---------------------------------------------------------------- helpers

def mul(p, q):
    """Rectangular exact matrix product on tuples of tuples."""
    inner = len(q)
    cols = len(q[0]) if inner else 0
    assert all(len(row) == inner for row in p)
    return tuple(
        tuple(sum(p[i][k] * q[k][j] for k in range(inner))
              for j in range(cols))
        for i in range(len(p))
    )


def add(p, q):
    return tuple(tuple(x + y for x, y in zip(rp, rq))
                 for rp, rq in zip(p, q))


def neg(p):
    return tuple(tuple(-x for x in row) for row in p)


def identity(n):
    return tuple(tuple(1 if i == j else 0 for j in range(n))
                 for i in range(n))


def zero(rows, cols):
    return tuple((0,) * cols for _ in range(rows))


def conj_flag(x, flag):
    """D_r^-1 X D_r exactly; asserts integrality, returns ints."""
    y = conjugate_by_diag(x, flag)
    assert is_integral(y)
    return to_int(y)


def conj_flag_inv(x, flag):
    """D_r X D_r^-1 as exact fractions (no integrality assumed)."""
    r = len(flag)
    return tuple(
        tuple(Fraction(x[i][j] * flag[i], flag[j]) for j in range(r))
        for i in range(r)
    )


def corner_partner(a, flag):
    """P = D_r^-1 A^-1 D_r for A in Gamma_0(D_r); integral by R0036."""
    return conj_flag(inverse_unimodular(a), flag)


# ---------------------------------------------- coordinates <-> matrices

def coords_valid(coords, flag, n):
    """Membership in Gamma_0(D_r) x Z^{r x s} x GL_s(Z) x Z^{s x r}
    x GL_s(Z), including shape checks, with s = n - r."""
    a, b, e, r_blk, s_blk = coords
    r = len(flag)
    s = n - r
    shapes = (
        len(a) == r and all(len(row) == r for row in a)
        and len(b) == r and all(len(row) == s for row in b)
        and len(e) == s and all(len(row) == s for row in e)
        and len(r_blk) == s and all(len(row) == r for row in r_blk)
        and len(s_blk) == s and all(len(row) == s for row in s_blk)
    )
    return (
        shapes
        and in_flag_gamma0_congruence(a, flag)
        and abs(det(e)) == 1
        and abs(det(s_blk)) == 1
    )


def assemble(coords, flag, n):
    """Theorem 1: (A,B,E,R,S) -> (H,K) with H = [[A,B],[0,E]],
    K = [[D_r^-1 A^-1 D_r, 0],[R, S]]."""
    a, b, e, r_blk, s_blk = coords
    r = len(flag)
    p = corner_partner(a, flag)
    h = tuple(
        tuple(a[i][j] if j < r else b[i][j - r] for j in range(n))
        if i < r else
        tuple(0 if j < r else e[i - r][j - r] for j in range(n))
        for i in range(n)
    )
    k = tuple(
        tuple(p[i][j] if j < r else 0 for j in range(n))
        if i < r else
        tuple(r_blk[i - r][j] if j < r else s_blk[i - r][j - r]
              for j in range(n))
        for i in range(n)
    )
    return h, k


def extract(h, k, flag, n):
    """Theorem 1, inverse direction: read the five free blocks off a
    stabilizing pair and assert the five determined blocks."""
    r = len(flag)
    a, b, c, e = blocks(h, r)
    p, q, r_blk, s_blk = blocks(k, r)
    assert is_zero(c) and is_zero(q)
    assert p == corner_partner(a, flag)
    coords = (a, b, e, r_blk, s_blk)
    assert coords_valid(coords, flag, n)
    return coords


# ------------------------------------------------------- K-side membership

def k_side_member(k, flag):
    """Theorem 1, K side: lower-parabolic with corner P satisfying
    D_r P D_r^-1 integral, i.e. (d_j/d_i) | P_ij for i < j."""
    r = len(flag)
    p, q, _, s_blk = blocks(k, r)
    return (
        abs(det(k)) == 1
        and is_zero(q)
        and abs(det(p)) == 1
        and abs(det(s_blk)) == 1
        and is_integral(conj_flag_inv(p, flag))
    )


def exists_integral_left_partner(k, flag, n):
    """Whether ANY unimodular H satisfies H D K = D, by solving the
    block equations over Q (mirror of exists_integral_partner).  With
    K = [[P,Q],[R,S]]: DK = [[D_r P, D_r Q],[0,0]], so A D_r P = D_r
    forces P unimodular and A = D_r P^-1 D_r^-1 integral; then Q = 0 is
    forced, and H = [[A,0],[0,I]] completes any solution."""
    r = len(flag)
    p, q, _, _ = blocks(k, r)
    if not is_zero(q) or abs(det(p)) != 1:
        return False
    return is_integral(conj_flag_inv(inverse_unimodular(p), flag))


# ------------------------------------------------------------- group law

def group_law(x, y, flag):
    """Theorem 2: coordinates of (H,K)*(H',K') = (HH', K'K).  The K
    side composes opposite (second factor's matrix on the left), since
    K acts on events by right multiplication."""
    a, b, e, r_blk, s_blk = x
    a2, b2, e2, r2, s2 = y
    p = corner_partner(a, flag)
    return (
        mul(a, a2),
        add(mul(a, b2), mul(b, e2)),
        mul(e, e2),
        add(mul(r2, p), mul(s2, r_blk)),
        mul(s2, s_blk),
    )


def group_identity(flag, n):
    r = len(flag)
    s = n - r
    return (identity(r), zero(r, s), identity(s), zero(s, r), identity(s))


def group_inverse(x, flag):
    """Theorem 2: (A,B,E,R,S)^-1 =
    (A^-1, -A^-1 B E^-1, E^-1, -S^-1 R D_r^-1 A D_r, S^-1)."""
    a, b, e, r_blk, s_blk = x
    ai = inverse_unimodular(a)
    ei = inverse_unimodular(e)
    si = inverse_unimodular(s_blk)
    return (
        ai,
        neg(mul(mul(ai, b), ei)),
        ei,
        neg(mul(mul(si, r_blk), conj_flag(a, flag))),
        si,
    )


# ------------------------------------------------------ events / payload

def payload(u, v, u0, v0, flag, n):
    """Theorem 3: coordinates of the event (U,V) relative to the base
    event (U0,V0), read off (U U0^-1, V0^-1 V)."""
    h = mul(u, inverse_unimodular(u0))
    k = mul(inverse_unimodular(v0), v)
    return extract(h, k, flag, n)


def replay(coords, u0, v0, flag, n):
    """Theorem 3, inverse: (A,B,E,R,S) -> the event (H U0, V0 K)."""
    h, k = assemble(coords, flag, n)
    return mul(h, u0), mul(v0, k)


def section_change(coords, g_coords, flag):
    """Theorem 4: payload relative to a new base event (U0',V0') is the
    right translate by g = (U0 U0'^-1, V0'^-1 V0):
    (Aa, Ab+Be, Ee, rho D_r^-1 A^-1 D_r + sigma R, sigma S)."""
    return group_law(coords, g_coords, flag)


def diff_coords(x, y, flag):
    """Theorem 5: coordinates of pi(x) * pi(y)^-1, section-independent."""
    return group_law(x, group_inverse(y, flag), flag)
