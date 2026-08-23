#!/usr/bin/env python3
"""The kuttaka (pulverizer) with its valli as a first-class trace.

Aryabhata's mutual-division cascade for a x - b y = c: the valli (quotient
column) is the exact replayable record; the solution is a family
(x + t b/g, y + t a/g); the ista convention (least positive) is an
explicit section.  The diagonal normalization cell of this branch's fiber
theory is assembled directly from the pulverizer's output, so the two
constructions are one.  Exact integers throughout.
"""

from math import gcd


def pulverize(a, b):
    """Mutual division on (|a|, |b|): returns (valli, g, x, y) with
    a x + b y = g = gcd(a, b) (signs handled), by back-substitution up
    the recorded quotient column."""
    if a == 0 and b == 0:
        raise ValueError("pulverizer needs a nonzero pair")
    sa = 1 if a >= 0 else -1
    sb = 1 if b >= 0 else -1
    r0, r1 = abs(a), abs(b)
    valli = []
    while r1:
        q, r = divmod(r0, r1)
        valli.append(q)
        r0, r1 = r1, r
    g = r0
    # back-substitution up the valli: solve |a| x + |b| y = g
    x, y = 1, 0
    for q in reversed(valli):
        x, y = y, x - q * y
    return valli, g, sa * x, sb * y


def valli_replay(a, b, valli):
    """Feed the recorded quotients back through the cascade: reproduces
    the remainder sequence exactly iff the valli is the true trace."""
    r0, r1 = abs(a), abs(b)
    for q in valli:
        if r1 == 0 or divmod(r0, r1)[0] != q:
            return False
        r0, r1 = r1, r0 - q * r1
    return r1 == 0


def solution_family(a, b, c, t_range):
    """Solutions of a x - b y = c over the given family window; empty iff
    g does not divide c."""
    valli, g, u, v = pulverize(a, b)
    if c % g:
        return []
    # a u + b v = g  =>  a (u c/g) - b (-v c/g) = c
    x0, y0 = u * (c // g), -v * (c // g)
    return [(x0 + t * (b // g), y0 + t * (a // g)) for t in t_range]


def is_solution(a, b, c, x, y):
    return a * x - b * y == c


def ista_section(a, b, c):
    """The least-positive convention: the unique family member with
    0 <= x < |b/g|.  This is a declared section, not a derived one."""
    valli, g, u, v = pulverize(a, b)
    if c % g:
        raise ValueError("no solution: gcd obstruction")
    x0, y0 = u * (c // g), -v * (c // g)
    step = b // g
    if step == 0:
        return x0, y0
    x = x0 % abs(step)
    t = (x - x0) // step
    return x, y0 + t * (a // g)


def cell_from_kuttaka(a, b):
    """Assemble the diagonal normalization cell (U, V, D) directly from
    the pulverizer: g = gcd, A = a/g, B = b/g, x A + y B = 1 from the
    pulverizer on (A, B), U = ((x, y), (-B, A)), V = ((1, -y B), (1, x A)),
    U diag(a,b) V = diag(g, ab/g)."""
    g = gcd(a, b)
    A, B = a // g, b // g
    _, one, x, y = pulverize(A, B)
    assert one == 1 and x * A + y * B == 1
    u = ((x, y), (-B, A))
    v = ((1, -y * B), (1, x * A))
    d = ((g, 0), (0, (a * b) // g))
    return u, v, d
