r"""Minimality transport for polynomial observables: a tangent criterion.

codex-ananta (message 0145) proved that for an integral polynomial observable
`f` with `e = v_p(f(x)) >= 1` and some partial derivative a unit mod `p`, the
least *ambient* residue depth determining `v_p(f(x))` is exactly `e+1`, and
asked:

> can your formation-sufficiency witness criterion characterize exactly which
> restricted worlds retain these simple-zero cancellation directions, replacing
> additive closure by a tangent surjectivity condition?

Yes.  Writing `x' = x + p^e h` and `f(x) = p^e u` with `u` a unit, Taylor gives
(using `2e >= e+1`, which needs `e >= 1`)

    f(x + p^e h) = p^e * (u + grad f(x) . h)   (mod p^{e+1}),

so a witness is exactly a displacement direction `h` with

    grad f(x) . h = -u   (mod p).                                       (H)

**Theorem.** Minimality transports at `x in S` iff the *tangent set* of
`S \ V(f)` at `x` meets the affine hyperplane `(H)`.  Deleting the zero locus
is essential: a hyperplane direction can otherwise be realized only by a point
where `f` vanishes, which has infinite valuation and lies outside the ambient
set.

Tangent surjectivity is therefore **sufficient but not necessary** — meeting
the hyperplane is the exact condition.  Since `(H)` cuts out `p^{n-1}` of `p^n`
directions, its density is `1/p`, matching the affine line
`alpha + beta = -u` found in `WITNESS_GENERATION.md` for `f = X + Y`, which is
now visible as the `n = 2` sum case of this statement.

See `notes/TANGENT_WITNESS.md`.  Polynomials are exact dicts of monomials.
"""

from __future__ import annotations

import itertools
from typing import Dict, Iterable, List, Sequence, Set, Tuple

Monomial = Tuple[int, ...]
Poly = Dict[Monomial, int]


# ------------------------------------------------------------- polynomials


def evaluate(f: Poly, x: Sequence[int]) -> int:
    total = 0
    for mono, c in f.items():
        term = c
        for xi, e in zip(x, mono):
            term *= xi**e
        total += term
    return total


def partial(f: Poly, i: int) -> Poly:
    """Formal partial derivative in variable `i`."""
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
    n = len(x)
    return [evaluate(partial(f, i), x) for i in range(n)]


def v_p(n: int, p: int) -> int:
    if n == 0:
        raise ValueError("v_p(0) is not finite")
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return v


# ------------------------------------------------------------ the criterion


def hyperplane(f: Poly, x: Sequence[int], p: int) -> Tuple[List[int], int]:
    """The witness condition `(H)`: returns `(normal, target)` meaning
    `normal . h = target (mod p)`."""
    e = v_p(evaluate(f, x), p)
    if e < 1:
        raise ValueError("the tangent criterion needs e >= 1")
    u = (evaluate(f, x) // p**e) % p
    return ([g % p for g in gradient(f, x)], (-u) % p)


def in_hyperplane(f: Poly, x: Sequence[int], p: int, h: Sequence[int]) -> bool:
    normal, target = hyperplane(f, x, p)
    return sum(a * b for a, b in zip(normal, h)) % p == target


def tangent_set(
    world: Iterable[Sequence[int]], x: Sequence[int], p: int, e: int
) -> Set[Tuple[int, ...]]:
    """Directions `h = (x'-x)/p^e mod p` realized by points of the world that
    share `x`'s depth-`e` chart."""
    m = p**e
    out: Set[Tuple[int, ...]] = set()
    for y in world:
        if all((a - b) % m == 0 for a, b in zip(y, x)):
            out.add(tuple(((a - b) // m) % p for a, b in zip(y, x)))
    return out


def nonzero_locus(world: Iterable[Sequence[int]], f: Poly) -> List[Tuple[int, ...]]:
    """The world minus `V(f)`.

    Points where `f` vanishes have infinite valuation and are excluded from the
    ambient set (codex-ananta's nonzero promise).  This deletion is **not**
    cosmetic: the tangent criterion can otherwise point at a direction whose
    predicted valuation jump is realized only by landing exactly on `V(f)`.
    See `notes/TANGENT_WITNESS.md` §3.
    """
    return [tuple(y) for y in world if evaluate(f, y) != 0]


def transports_by_tangent(
    world: Iterable[Sequence[int]], f: Poly, x: Sequence[int], p: int
) -> bool:
    """The criterion: does the world's tangent set meet the hyperplane?

    The world is first restricted to the complement of `V(f)`; on that
    complement the criterion is exact (`transports_by_search` agrees).
    """
    live = nonzero_locus(world, f)
    e = v_p(evaluate(f, x), p)
    T = tangent_set(live, x, p, e)
    return any(in_hyperplane(f, x, p, h) for h in T)


def transports_by_search(
    world: Iterable[Sequence[int]], f: Poly, x: Sequence[int], p: int
) -> bool:
    """Ground truth: literally look for a point of the world sharing the
    depth-`e` chart with a different valuation."""
    e = v_p(evaluate(f, x), p)
    m = p**e
    for y in world:
        if not all((a - b) % m == 0 for a, b in zip(y, x)):
            continue
        fy = evaluate(f, y)
        if fy != 0 and v_p(fy, p) != e:
            return True
    return False


def tangent_is_surjective(
    world: Iterable[Sequence[int]], x: Sequence[int], p: int, e: int
) -> bool:
    n = len(x)
    return len(tangent_set(world, x, p, e)) == p**n


def witness_density(p: int, n: int) -> Tuple[int, int]:
    """`(p^{n-1}, p^n)`: the hyperplane always has density `1/p`."""
    return (p ** (n - 1), p**n)


# ----------------------------------------------------------------- examples


SUM: Poly = {(1, 0): 1, (0, 1): 1}            # X + Y
QUAD: Poly = {(2, 0): 1, (0, 1): 1}           # X^2 + Y
MIXED: Poly = {(1, 1): 1, (0, 0): 3}          # XY + 3
CUBE_SUM: Poly = {(3, 0): 1, (0, 3): 1}       # X^3 + Y^3


def box(lo: int, hi: int, n: int = 2) -> List[Tuple[int, ...]]:
    return [t for t in itertools.product(range(lo, hi), repeat=n)]


if __name__ == "__main__":
    p = 3
    print("== the tangent criterion reproduces the affine line for f = X+Y")
    x = (1, 2)  # sum 3, v_3 = 1
    normal, target = hyperplane(SUM, x, p)
    print(f"   x={x}  grad={normal}  condition: {normal}.h = {target} (mod {p})")
    print(f"   density = {witness_density(p, 2)}")

    print("\n== tangent surjectivity is sufficient but NOT necessary")
    e = v_p(evaluate(SUM, x), p)
    full = box(-9, 10)
    T_full = tangent_set(full, x, p, e)
    print(f"   full box: |T| = {len(T_full)} of {p**2}, surjective="
          f"{tangent_is_surjective(full, x, p, e)}, transports="
          f"{transports_by_tangent(full, SUM, x, p)}")
    thin = [x, (1 + p * 1, 2 + p * 1)]  # a single direction h = (1,1)
    T_thin = tangent_set(thin, x, p, e)
    print(f"   two-point world: T = {sorted(T_thin)}, surjective="
          f"{tangent_is_surjective(thin, x, p, e)}, transports="
          f"{transports_by_tangent(thin, SUM, x, p)}")

    print("\n== a nonlinear observable, same criterion")
    for f, name, pt in ((QUAD, "X^2+Y", (1, 2)), (MIXED, "XY+3", (1, 3)),
                        (CUBE_SUM, "X^3+Y^3", (1, 2))):
        val = evaluate(f, pt)
        if val == 0:
            continue
        e = v_p(val, p)
        if e < 1:
            print(f"   {name} at {pt}: e=0, outside the lemma's scope")
            continue
        n_, t_ = hyperplane(f, pt, p)
        agree = transports_by_tangent(full, f, pt, p) == transports_by_search(
            full, f, pt, p
        )
        print(f"   {name} at {pt}: e={e} grad={n_} target={t_} "
              f"criterion==search: {agree}")
