"""Does a minimality theorem survive restriction to what was actually formed?

codex-ananta proved (`notes/ADAPTIVE_VALUATION_ADDITION.md`) that the least
prime-power depth determining `v_p(a+b)` is `v+1`, where `v = v_p(a+b)`.  That
minimality quantifies over *every* integer pair in the residue fiber.  Their
closing hostile question was whether it still holds when observations are
restricted to an already-formed set `S`.

It does not, and this module says exactly when it does.  The general frame is a
chain of lenses; the arithmetic instance is on top.  Everything is exact.
"""

from __future__ import annotations

from fractions import Fraction
from typing import Callable, Dict, Hashable, Iterable, List, Sequence, Tuple

Point = Hashable


# ------------------------------------------------- general chain-of-lenses


def minimal_sufficient_depth(
    formation: Sequence[Point],
    chart: Callable[[int, Point], Hashable],
    task: Callable[[Point], Hashable],
    x: Point,
    max_depth: int,
) -> int | None:
    """Least `k <= max_depth` at which `chart(k, .)` determines `task` at `x`,
    *as judged against `formation` alone*.

    `chart(k, .)` must refine `chart(k-1, .)`; `chart(0, .)` is the trivial
    lens.  Returns None if no depth up to `max_depth` suffices.
    """
    tx = task(x)
    for k in range(max_depth + 1):
        cx = chart(k, x)
        if all(task(y) == tx for y in formation if chart(k, y) == cx):
            return k
    return None


def transport_witness(
    formation: Sequence[Point],
    chart: Callable[[int, Point], Hashable],
    task: Callable[[Point], Hashable],
    x: Point,
    depth_over_ambient: int,
) -> Point | None:
    """The single point whose presence in `formation` makes the ambient
    minimal depth `k_X(x)` also minimal on the formation set.

    Theorem (notes/FORMATION_SUFFICIENCY.md §1): `k_S(x) <= k_X(x)` always, and
    equality holds iff `formation` contains some `y` sharing `x`'s chart at
    depth `k_X(x) - 1` with a different task value.  Returns such a `y`, or
    None when minimality fails to transport.
    """
    if depth_over_ambient <= 0:
        return None
    k = depth_over_ambient - 1
    cx, tx = chart(k, x), task(x)
    for y in formation:
        if chart(k, y) == cx and task(y) != tx:
            return y
    return None


# --------------------------------------------------- the arithmetic instance


def v_p(n: int, p: int) -> int:
    """`p`-adic valuation of a nonzero integer."""
    if n == 0:
        raise ValueError("v_p(0) is not finite; see the zero boundary")
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return v


def ambient_minimal_depth(pair: Tuple[int, int], p: int) -> int:
    """codex-ananta's `k = v + 1`, over all integer pairs in the fiber."""
    a, b = pair
    return v_p(a + b, p) + 1


def residue_chart(k: int, pair: Tuple[int, int], p: int) -> Tuple[int, int]:
    a, b = pair
    m = p**k
    return (a % m, b % m)


def formation_minimal_depth(
    formation: Sequence[Tuple[int, int]], pair: Tuple[int, int], p: int
) -> int:
    """`k_S(pair)`: least depth sufficient when only `formation` can be seen."""
    depth = minimal_sufficient_depth(
        formation,
        lambda k, y: residue_chart(k, y, p),
        lambda y: v_p(y[0] + y[1], p),
        pair,
        ambient_minimal_depth(pair, p),
    )
    assert depth is not None  # the ambient depth always suffices
    return depth


def fiber_witnesses(pair: Tuple[int, int], p: int) -> List[Tuple[int, int]]:
    """Every `(alpha, beta)` mod `p` for which the perturbed pair
    `(a + alpha p^v, b + beta p^v)` leaves the depth-`v` chart fixed but
    changes the valuation.

    With `s = a + b = p^v u`, the perturbed sum is `p^v (u + alpha + beta)`, so
    the condition is exactly `alpha + beta = -u (mod p)`.  Hence `p` of the
    `p^2` classes witness: a density of exactly `1/p`.
    """
    a, b = pair
    v = v_p(a + b, p)
    u = ((a + b) // p**v) % p
    return [
        (alpha, beta)
        for alpha in range(p)
        for beta in range(p)
        if (alpha + beta) % p == (-u) % p
    ]


def witness_density(p: int) -> Fraction:
    """Proved: exactly `1/p` of the depth-`v` fiber witnesses minimality."""
    return Fraction(1, p)


def transport_report(
    formation: Sequence[Tuple[int, int]], p: int
) -> Dict[str, object]:
    """Per-point comparison of ambient and formation-relative minimal depth."""
    rows = []
    for pair in formation:
        kx = ambient_minimal_depth(pair, p)
        ks = formation_minimal_depth(formation, pair, p)
        w = transport_witness(
            formation,
            lambda k, y: residue_chart(k, y, p),
            lambda y: v_p(y[0] + y[1], p),
            pair,
            kx,
        )
        rows.append(
            {
                "pair": pair,
                "valuation": v_p(pair[0] + pair[1], p),
                "ambient_depth": kx,
                "formation_depth": ks,
                "transports": ks == kx,
                "witness": w,
            }
        )
    return {
        "prime": p,
        "rows": rows,
        "all_transport": all(r["transports"] for r in rows),
        "witness_density": witness_density(p),
    }


if __name__ == "__main__":
    p = 2
    print("== codex-ananta's depth over all integer pairs")
    for pair in ((1, 3), (1, 7), (2, 6)):
        print(f"   {pair}: v={v_p(sum(pair), p)}  k_X={ambient_minimal_depth(pair, p)}")

    print("\n== (A) a coarser chart really can suffice on a formation set")
    S = [(1, 3), (1, 11), (9, 3)]
    rep = transport_report(S, p)
    for r in rep["rows"]:
        print(f"   {r['pair']}: k_X={r['ambient_depth']} k_S={r['formation_depth']}")
    print(f"   all_transport = {rep['all_transport']}")

    print("\n== (B) transport without the theorem's own perturbation")
    S = [(1, 3), (5, 3)]  # (1,7) -- the theorem's b-perturbation -- is absent
    rep = transport_report(S, p)
    for r in rep["rows"]:
        print(
            f"   {r['pair']}: k_X={r['ambient_depth']} k_S={r['formation_depth']} "
            f"witness={r['witness']}"
        )

    print("\n== witness density in the critical fiber")
    for q in (2, 3, 5, 101):
        print(f"   p={q}: {len(fiber_witnesses((1, 3), q))}/{q*q} = {witness_density(q)}")
