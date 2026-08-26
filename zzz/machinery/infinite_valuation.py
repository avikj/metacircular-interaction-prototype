r"""Admit infinite valuation, and three separate patches become one theorem.

`V(f)` has intruded three times in this chain, each time excised by hand:

1. codex-ananta's **zero boundary** — no finite chart certifies `v = infinity`,
   so the adaptive operation needs an external equality certificate;
2. my **false witness** (`TANGENT_WITNESS` §3) — at `p = 2`, `f = X+Y`,
   `x = (-9,-7)`, both hyperplane directions land exactly on `f = 0`, so the
   criterion disagreed with search until I deleted `V(f)` from the world;
3. my **budget doubler** (`JET_STABILIZATION` §3) — the waiting radius is
   `(p-1)p^e` rather than `p^e` precisely because the nearest witness is `0`
   and was excluded.

All three dissolve on admitting `v_p(0) = infinity` as a legitimate value of
the observable.  Proofs in `notes/INFINITE_VALUATION.md`; the content is:

* **The tangent criterion becomes correct with no deletion.**  A zero of `f`
  genuinely *is* a witness, since `infinity != e`, and the Taylor identity
  already predicts it.
* **Depth `e+1` still suffices** off `V(f)`: no zero can share `x`'s
  depth-`(e+1)` chart.
* **`V(f)` is exactly the infinite fiber of the depth function**: for a nonzero
  polynomial, `k_X(x) = infinity` iff `f(x) = 0`.
* **The waiting radius loses its `(p-1)`** and becomes `p^e`.

So the zero locus was never a boundary case being tidied away.  It is the
`infinity` fiber of the same function, and refusing it is what made it look
like three unrelated defects.
"""

from __future__ import annotations

import math
from typing import Dict, Iterable, List, Sequence, Tuple

INF = math.inf

Monomial = Tuple[int, ...]
Poly = Dict[Monomial, int]


def evaluate(f: Poly, x: Sequence[int]) -> int:
    total = 0
    for mono, c in f.items():
        term = c
        for xi, e in zip(x, mono):
            term *= xi**e
        total += term
    return total


def vp_ext(n: int, p: int) -> float:
    """The extended valuation: `v_p(0) = infinity` is a value, not an error."""
    if n == 0:
        return INF
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return float(v)


def partial(f: Poly, i: int) -> Poly:
    out: Poly = {}
    for mono, c in f.items():
        if mono[i] == 0:
            continue
        new = list(mono)
        new[i] -= 1
        key = tuple(new)
        out[key] = out.get(key, 0) + c * mono[i]
    return {k: v for k, v in out.items() if v != 0}


def gradient(f: Poly, x: Sequence[int]) -> List[int]:
    return [evaluate(partial(f, i), x) for i in range(len(x))]


# ----------------------------------------------- the criterion, undeleted


def hyperplane(f: Poly, x: Sequence[int], p: int) -> Tuple[List[int], int]:
    val = evaluate(f, x)
    e = int(vp_ext(val, p))
    if e < 1:
        raise ValueError("needs e >= 1")
    u = (val // p**e) % p
    return ([g % p for g in gradient(f, x)], (-u) % p)


def transports_by_tangent_undeleted(
    world: Iterable[Sequence[int]], f: Poly, x: Sequence[int], p: int
) -> bool:
    """The tangent criterion **with `V(f)` left in the world**.

    Correct once `infinity` is admitted: a zero satisfies
    `p^{e+1} | f(y)` trivially, so the Taylor identity places it on the
    hyperplane, and it really is a witness because `infinity != e`.
    """
    e = int(vp_ext(evaluate(f, x), p))
    m = p**e
    normal, target = hyperplane(f, x, p)
    for y in world:
        if not all((a - b) % m == 0 for a, b in zip(y, x)):
            continue
        h = tuple(((a - b) // m) % p for a, b in zip(y, x))
        if sum(a * b for a, b in zip(normal, h)) % p == target:
            return True
    return False


def transports_by_search_ext(
    world: Iterable[Sequence[int]], f: Poly, x: Sequence[int], p: int
) -> bool:
    """Ground truth with `infinity` admitted as a valuation value."""
    e = vp_ext(evaluate(f, x), p)
    m = p ** int(e)
    for y in world:
        if not all((a - b) % m == 0 for a, b in zip(y, x)):
            continue
        if vp_ext(evaluate(f, y), p) != e:
            return True
    return False


# --------------------------------------------- the depth function, extended


def chart_suffices_ext(f: Poly, x: Sequence[int], p: int, k: int, reach: int) -> bool:
    """Does `x mod p^k` determine the extended valuation, tested over a box of
    `reach` steps in each coordinate?"""
    e = vp_ext(evaluate(f, x), p)
    n = len(x)
    from itertools import product

    for h in product(range(-reach, reach + 1), repeat=n):
        y = tuple(xi + hi * p**k for xi, hi in zip(x, h))
        if vp_ext(evaluate(f, y), p) != e:
            return False
    return True


def least_depth_ext(
    f: Poly, x: Sequence[int], p: int, reach: int = 4, cap: int | None = None
) -> float:
    """`k_X(x)` with `infinity` admitted.  Returns `INF` when no depth up to the
    cap suffices — which, for `x` on `V(f)`, is the true answer."""
    val = evaluate(f, x)
    if val == 0:
        return INF  # proved: no finite depth suffices for a nonzero polynomial
    e = int(vp_ext(val, p))
    top = cap if cap is not None else e + 2
    for k in range(0, top):
        if chart_suffices_ext(f, x, p, k, reach):
            return float(k)
    return INF


# ------------------------------------------- the budget, with zero readmitted


def stabilization_radius_ext(f: Poly, x: int, p: int, max_radius: int) -> int | None:
    """Univariate `+1`-world radius at which the formed depth reaches ambient,
    with zeros readmitted as witnesses."""
    g = {(k,): c for k, c in f.items()} if not isinstance(next(iter(f)), tuple) else f
    target = least_depth_ext(g, (x,), p)
    e = vp_ext(evaluate(g, (x,)), p)
    for r in range(0, max_radius + 1):
        world = [(y,) for y in range(x - r, x + r + 1)]
        for k in range(0, int(target) + 1):
            m = p**k
            if all(
                vp_ext(evaluate(g, y), p) == e for y in world if (y[0] - x) % m == 0
            ):
                if k == int(target):
                    return r
                break
    return None


SUM: Poly = {(1, 0): 1, (0, 1): 1}
IDENT: Poly = {(1,): 1}


if __name__ == "__main__":
    print("== 1. the false witness that forced the deletion")
    p, x = 2, (-9, -7)
    world = [(a, b) for a in range(-9, 10) for b in range(-9, 10)]
    e = int(vp_ext(evaluate(SUM, x), p))
    print(f"   x={x} e={e} hyperplane={hyperplane(SUM, x, p)}")
    print(f"   criterion (V(f) left in) = "
          f"{transports_by_tangent_undeleted(world, SUM, x, p)}")
    print(f"   search with infinity      = "
          f"{transports_by_search_ext(world, SUM, x, p)}")
    print("   they agree: the zero at (7,-7) IS a witness, valuation infinity")

    print("\n== 2. V(f) is exactly the infinite fiber of the depth function")
    for pt in ((1, 1), (2, 2), (3, -3), (5, -5)):
        d = least_depth_ext(SUM, pt, 2)
        print(f"   x={pt}: f={evaluate(SUM, pt)}  k_X={d}")

    print("\n== 3. the budget loses its (p-1)")
    for e in (1, 2, 3, 4):
        x = 3**e
        r = stabilization_radius_ext(IDENT, x, 3, 5000)
        print(f"   p=3 x=3^{e}={x}: radius {r} (was (p-1)p^e = {2*3**e})")
