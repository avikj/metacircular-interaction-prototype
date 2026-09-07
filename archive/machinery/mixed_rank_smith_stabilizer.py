"""Exact replay for notes/MIXED_RANK_SMITH_STABILIZER.md (cf-tessera).

For a normalized rank-r Smith endpoint D = blockdiag(D_r, 0) in n x n,
(H, K) stabilizes D two-sidedly iff H is upper-parabolic with corner
A in Gamma_0(D_r) and K is lower-parabolic with corner D_r^-1 A^-1 D_r;
tails are free.  One-sided stabilization collapses the corner to I.
Exact integers/fractions throughout.
"""

from fractions import Fraction

from flag_congruence_smith_stabilizer import (
    det,
    in_flag_gamma0_congruence,
    inverse_unimodular,
    mat_mul,
)


def mixed_diag(flag, n):
    """blockdiag(diag(flag), 0) in n x n."""
    r = len(flag)
    return tuple(
        tuple(
            flag[i] if i == j and i < r else 0 for j in range(n)
        )
        for i in range(n)
    )


def blocks(h, r):
    """Split an n x n matrix into (A, B, C, E) at block size r."""
    a = tuple(row[:r] for row in h[:r])
    b = tuple(row[r:] for row in h[:r])
    c = tuple(row[:r] for row in h[r:])
    e = tuple(row[r:] for row in h[r:])
    return a, b, c, e


def is_zero(m):
    return all(x == 0 for row in m for x in row)


def two_sided_stabilizes(h, k, flag, n):
    d = mixed_diag(flag, n)
    return mat_mul(mat_mul(h, d), k) == d


def h_side_member(h, flag):
    """Theorem 1, H side: upper-parabolic with corner in Gamma_0(D_r)."""
    r = len(flag)
    a, _, c, e = blocks(h, r)
    return (
        abs(det(h)) == 1
        and is_zero(c)
        and abs(det(a)) == 1
        and abs(det(e)) == 1
        and in_flag_gamma0_congruence(a, flag)
    )


def one_sided_stabilizes(h, flag, n):
    d = mixed_diag(flag, n)
    return mat_mul(h, d) == d


def one_sided_member(h, flag):
    """One-sided collapse: corner exactly I, C = 0, tails free."""
    r = len(flag)
    a, _, c, e = blocks(h, r)
    identity = tuple(
        tuple(1 if i == j else 0 for j in range(r)) for i in range(r)
    )
    return (
        abs(det(h)) == 1 and is_zero(c) and a == identity
        and abs(det(e)) == 1
    )


def partner(h, flag, n):
    """The forced K for a member H: corner D_r^-1 A^-1 D_r, tails zero
    except an identity E-block (the canonical section of the tail
    freedom)."""
    r = len(flag)
    a, _, _, _ = blocks(h, r)
    ai = inverse_unimodular(a)
    corner = tuple(
        tuple(Fraction(ai[i][j] * flag[j], flag[i]) for j in range(r))
        for i in range(r)
    )
    assert all(x.denominator == 1 for row in corner for x in row)
    corner = tuple(tuple(int(x) for x in row) for row in corner)
    return tuple(
        tuple(
            corner[i][j] if i < r and j < r
            else (1 if i == j else 0) if i >= r and j >= r
            else 0
            for j in range(n)
        )
        for i in range(n)
    )


def exists_integral_partner(h, flag, n):
    """Whether ANY unimodular K satisfies H D K = D: by the theorem this
    holds iff h_side_member; this function checks it independently by
    solving the block equations over Q."""
    r = len(flag)
    a, _, c, _ = blocks(h, r)
    # A D_r P = D_r forces A, P in GL_r(Z); then P is nonsingular and
    # C D_r P = 0 forces C = 0.
    if not is_zero(c) or abs(det(a)) != 1:
        return False
    ai = inverse_unimodular(a)
    corner = tuple(
        tuple(Fraction(ai[i][j] * flag[j], flag[i]) for j in range(r))
        for i in range(r)
    )
    return all(x.denominator == 1 for row in corner for x in row)
