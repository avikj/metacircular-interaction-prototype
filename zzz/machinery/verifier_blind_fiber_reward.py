"""Exact replay for notes/VERIFIER_BLIND_FIBER_REWARD.md (cf-tessera).

Theorem A: every verifier observable (function of source, endpoint, Smith
invariants) is constant on the event set of a nonsingular 2x2 M.
Theorem B: trace formats discriminate events exactly by their induced
partition of Gamma_0(m); det gives the two kernel cosets; Bezout recording
covers only the unipotent subgroup; injective formats replay.
R0027 section mechanism: an external cost (word length in declared
generators) separates fiber points all verifier observables conflate.
Exact integers throughout.
"""

from math import gcd

from diagonal_smith_congruence_torsor import in_gamma0
from hecke_coset_smith_assembly import det2, inv_unimodular, mat_mul, smith_2x2
from total_smith_replay_payload import (
    elementary_divisors,
    is_event,
    payload,
    replay,
    section,
)


def verifier_observables(mat, u, v):
    """A family of endpoint-verifier data for one event: everything the
    task predicate can see.  Returns a tuple (so equality = agreement of
    the whole family)."""
    d = mat_mul(mat_mul(u, mat), v)
    e1, e2 = elementary_divisors(mat)
    return (
        mat,                      # source
        d,                        # endpoint reached
        (e1, e2),                 # Smith invariants
        abs(det2(mat)),           # |det|
        d == ((e1, 0), (0, e2)),  # success predicate
        e2 // e1,                 # level
    )


def det_format(h):
    """Sign supervision: records det of the payload."""
    return det2(h)


def bezout_format(h):
    """Bezout recording: the shift t if the payload is unipotent
    upper-triangular [[1,-t],[0,1]], else the non-representable marker."""
    if h[0][0] == 1 and h[1][1] == 1 and h[1][0] == 0:
        return ("t", -h[0][1])
    return ("bottom",)


def unipotent(t):
    return ((1, -t), (0, 1))


GENERATORS_CACHE = {}


def gamma0_generating_set(m):
    """A declared finite symmetric generating-ish set for word-cost
    purposes (NOT claimed to generate Gamma_0(m); the cost below is a
    declared external cost on a declared alphabet, which is all R0027
    Section 4 requires)."""
    s = [unipotent(1), unipotent(-1), ((1, 0), (m, 1)), ((1, 0), (-m, 1)),
         ((1, 0), (0, -1)), ((-1, 0), (0, 1))]
    return s


def word_cost(h, m, radius=4):
    """Length of a shortest product of declared alphabet letters equal to
    h, up to the given radius; None if not reached.  Exact BFS."""
    identity = ((1, 0), (0, 1))
    if h == identity:
        return 0
    frontier = {identity}
    seen = {identity}
    for depth in range(1, radius + 1):
        nxt = set()
        for g in frontier:
            for s in gamma0_generating_set(m):
                gg = mat_mul(g, s)
                if gg == h:
                    return depth
                if gg not in seen:
                    seen.add(gg)
                    nxt.add(gg)
        frontier = nxt
    return None
