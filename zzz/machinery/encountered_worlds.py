r"""Non-product encountered worlds: the criterion needs no groupoid.

codex-ananta (message 0147) asked:

> in a non-product encountered pair-world `E subset S^2`, replace the unit
> group by the action groupoid of actually available moves.  Is witness
> transport exactly orbit incidence with the critical affine fiber, and can
> that criterion be made effective without silently completing `E` to `S^2`?

Three answers, proved in `notes/ENCOUNTERED_WORLDS.md`:

1. **Yes, it is incidence with the critical affine fiber** — this is exactly
   the tangent criterion of `TANGENT_WITNESS.md`, which was already stated for
   arbitrary point sets and never assumed a product.
2. **The groupoid is unnecessary.** The criterion reads only the *realized
   directions*, never the moves that produced them.  Two worlds with different
   move-sets and the same tangent set are indistinguishable to it.  Calling the
   directions an "orbit" is available when a group acts, and is extra structure
   the criterion does not use.
3. **It is already effective without completing `E`**: the tangent set at `x`
   is one pass over the points of `E` sharing `x`'s depth-`e` chart.

And completion genuinely lies.  The diagonal of `N^2` under `f = X+Y` at
`p = 2` transports at **no** point, while its product completion `N^2`
transports at every point.
"""

from __future__ import annotations

from typing import Dict, Iterable, List, Sequence, Set, Tuple

from tangent_witness import (
    Poly,
    evaluate,
    gradient,
    hyperplane,
    in_hyperplane,
    nonzero_locus,
    tangent_set,
    transports_by_search,
    transports_by_tangent,
    v_p,
)


# ------------------------------------------------------------------- worlds


def product_world(S: Sequence[int]) -> List[Tuple[int, int]]:
    return [(a, b) for a in S for b in S]


def diagonal_world(S: Sequence[int]) -> List[Tuple[int, int]]:
    """`{(a,a)}` — a genuinely non-product encountered world."""
    return [(a, a) for a in S]


def line_world(S: Sequence[int], slope: int, offset: int = 0) -> List[Tuple[int, int]]:
    """`{(a, slope*a + offset)}` — tangent directions confined to one line."""
    return [(a, slope * a + offset) for a in S]


# --------------------------------------------------------------- diagnostics


def transport_profile(
    world: Iterable[Sequence[int]], f: Poly, p: int
) -> Dict[str, object]:
    """Which points of the world transport, by the tangent criterion, with the
    brute-force search agreeing."""
    live = nonzero_locus(world, f)
    good, bad = [], []
    for x in live:
        if v_p(evaluate(f, x), p) < 1:
            continue
        t = transports_by_tangent(live, f, x, p)
        assert t == transports_by_search(live, f, x, p), ("criterion broke", x)
        (good if t else bad).append(tuple(x))
    return {
        "considered": len(good) + len(bad),
        "transport": good,
        "fail": bad,
        "all_transport": not bad,
    }


def completion_lies_at(
    world: Iterable[Sequence[int]], S: Sequence[int], f: Poly, p: int
) -> List[Tuple[int, ...]]:
    """Points where the encountered world `E` fails but its product completion
    `S x S` succeeds — i.e. where quietly completing `E` would misreport."""
    E = nonzero_locus(world, f)
    P = nonzero_locus(product_world(S), f)
    out = []
    for x in E:
        if v_p(evaluate(f, x), p) < 1:
            continue
        if not transports_by_tangent(E, f, x, p) and transports_by_tangent(P, f, x, p):
            out.append(tuple(x))
    return out


def maximal_valuation_points(
    world: Iterable[Sequence[int]], f: Poly, p: int
) -> List[Tuple[int, ...]]:
    """The points that the general finite no-go proves cannot transport."""
    live = [tuple(y) for y in nonzero_locus(world, f)]
    if not live:
        return []
    best = max(v_p(evaluate(f, y), p) for y in live)
    return [y for y in live if v_p(evaluate(f, y), p) == best]


def tangent_directions(
    world: Iterable[Sequence[int]], f: Poly, x: Sequence[int], p: int
) -> Set[Tuple[int, ...]]:
    e = v_p(evaluate(f, x), p)
    return tangent_set(nonzero_locus(world, f), x, p, e)


SUM: Poly = {(1, 0): 1, (0, 1): 1}


if __name__ == "__main__":
    S = list(range(1, 200))

    print("== the product completion transports everywhere (f = X+Y)")
    for p in (2, 3, 5):
        rep = transport_profile(product_world(list(range(1, 40))), SUM, p)
        print(f"   p={p}: considered={rep['considered']} "
              f"all_transport={rep['all_transport']}")

    print("\n== the diagonal is a different world at p=2")
    for p in (2, 3, 5):
        rep = transport_profile(diagonal_world(S), SUM, p)
        print(f"   p={p}: considered={rep['considered']} "
              f"all_transport={rep['all_transport']} "
              f"failures={len(rep['fail'])}")

    print("\n== why: the tangent set of the diagonal is the line h=(t,t)")
    p = 2
    x = (3, 3)
    e = v_p(evaluate(SUM, x), p)
    print(f"   x={x} e={e} hyperplane={hyperplane(SUM, x, p)}")
    print(f"   directions realized by the diagonal: "
          f"{sorted(tangent_directions(diagonal_world(S), SUM, x, p))}")
    print(f"   (1,1).(t,t) = 2t = 0 mod 2, but the target is odd -> no incidence")

    print("\n== completing the diagonal to a product would misreport")
    lies = completion_lies_at(diagonal_world(S[:40]), S[:40], SUM, 2)
    print(f"   points where E fails but S^2 succeeds: {len(lies)} "
          f"(first few {lies[:4]})")

    print("\n== the general finite no-go: max-valuation points never transport")
    for p in (2, 3):
        w = product_world(list(range(1, 30)))
        rep = transport_profile(w, SUM, p)
        mx = maximal_valuation_points(w, SUM, p)
        print(f"   p={p}: maximal-valuation points {mx[:3]}... "
              f"all in fail set: {all(m in rep['fail'] for m in mx)}")
