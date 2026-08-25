"""Exact replay for notes/TOTAL_SMITH_REPLAY_PAYLOAD.md (cf-tessera).

For nonsingular 2x2 integer M with elementary divisors (e1, e2) and level
m = e2/e1, the set of normalization events (U, V) with U M V = diag(e1, e2)
is a regular Gamma_0(m)-torsor; relative to the deterministic Euclidean
section smith_2x2, the payload pi(U, V) = U U0^-1 is a bijection onto
Gamma_0(m) with explicit replay.  Exact integers throughout.
"""

from math import gcd

# in_gamma0 here is the GL_2 version (det = +-1): payloads carry the sign.
from diagonal_smith_congruence_torsor import conjugate_by_diag, in_gamma0
from hecke_coset_smith_assembly import (
    det2,
    inv_unimodular,
    mat_mul,
    smith_2x2,
)


def elementary_divisors(mat):
    e1 = gcd(gcd(mat[0][0], mat[0][1]), gcd(mat[1][0], mat[1][1]))
    e2 = abs(det2(mat)) // e1
    return (e1, e2)


def section(mat):
    """The deterministic base event (U0, V0, D) from the Euclidean
    normalizer."""
    u0, v0 = smith_2x2(mat)
    d = mat_mul(mat_mul(u0, mat), v0)
    return u0, v0, d


def payload(u, u0):
    """pi(U, V) = U U0^-1; lies in Gamma_0(e2/e1)."""
    return mat_mul(u, inv_unimodular(u0))


def replay(h, u0, v0, d):
    """pi^-1(H) = (H U0, V0 D^-1 H^-1 D)."""
    k = conjugate_by_diag(inv_unimodular(h), d[0][0], d[1][1])
    return mat_mul(h, u0), mat_mul(v0, k)


def is_event(u, v, mat, d):
    return (
        abs(det2(u)) == 1
        and abs(det2(v)) == 1
        and mat_mul(mat_mul(u, mat), v) == d
    )
