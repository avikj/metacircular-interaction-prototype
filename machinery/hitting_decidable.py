r"""Hitting the critical witness set is a finite question.

`HITTING_TIME` seed 2 asked: **when does a union of never-hitting rules hit?**
Last turn I showed a never-hitting move can strongly *accelerate* one that
hits, and left the enabling question open.

The whole question collapses.  For the identity observable at `x = p^e`, the
witness set is `W(x) = p^{e+1} Z` (points sharing the depth-`e` chart with a
different valuation are exactly the multiples of `p^{e+1}`, including `0`).  An
affine move `y -> g y + c` descends to `Z/p^{e+1}`.  So:

> **Hitting is reachability of `0` from `p^e` in `Z/p^{e+1}`** under the induced
> affine maps — a finite-state question, decidable by breadth-first search.

Verified against the unbounded search of `hitting_time.py` on 16 rule/prime/
depth combinations.  Consequences, all in `notes/HITTING_DECIDABLE.md`:

* **pure multiplicative** `{y -> g_i y}`: hits **iff** `p | g_i` for some `i`;
* **pure additive** `{y -> y +- c_i}`: hits **iff** `v_p(gcd c_i) <= e`;
* **no emergence in either natural family** — and the reason is structural: a
  never-hitting additive rule adds multiples of `p^{e+1}`, so it is the
  *identity* on `Z/p^{e+1}` and can contribute nothing to any union; a
  never-hitting multiplicative rule multiplies by a unit, preserving the
  valuation exactly;
* **but emergence is real for general affine rules.**  Minimal witness, at
  `p = 2` in `Z/4`: `y -> 1` and `y -> 2y + 2` each never reach `0` from `2`,
  and together they do, by `2 -> 1 -> 0`.

So a never-hitting move can accelerate (last turn) and can even *enable* — but
enabling requires leaving the multiplicative and additive families.
"""

from __future__ import annotations

from collections import deque
from math import gcd
from typing import Dict, Iterable, List, Sequence, Tuple

Affine = Tuple[int, int]  # y -> g*y + c


def v_p(n: int, p: int) -> int:
    if n == 0:
        raise ValueError("v_p(0) is not finite")
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return v


def hits(p: int, e: int, moves: Sequence[Affine]) -> bool:
    """Can `0` be reached from `p^e` in `Z/p^{e+1}`?  Decides hitting."""
    M = p ** (e + 1)
    start = p**e % M
    if start == 0:
        return True
    seen = {start}
    frontier = deque([start])
    while frontier:
        y = frontier.popleft()
        for g, c in moves:
            z = (g * y + c) % M
            if z == 0:
                return True
            if z not in seen:
                seen.add(z)
                frontier.append(z)
    return False


def witness_path(p: int, e: int, moves: Sequence[Affine]) -> List[int] | None:
    """A concrete route from `p^e` to `0` in `Z/p^{e+1}`, or None."""
    M = p ** (e + 1)
    start = p**e % M
    prev: Dict[int, Tuple[int, Affine] | None] = {start: None}
    frontier = deque([start])
    while frontier:
        y = frontier.popleft()
        for mv in moves:
            z = (mv[0] * y + mv[1]) % M
            if z in prev:
                continue
            prev[z] = (y, mv)
            if z == 0:
                path = [0]
                cur = 0
                while prev[cur] is not None:
                    cur = prev[cur][0]
                    path.append(cur)
                return list(reversed(path))
            frontier.append(z)
    return None


# ----------------------------------------------------------- the two families


def multiplicative(gs: Iterable[int]) -> List[Affine]:
    return [(g, 0) for g in gs]


def additive(cs: Iterable[int]) -> List[Affine]:
    out: List[Affine] = []
    for c in cs:
        out.append((1, c))
        out.append((1, -c))
    return out


def multiplicative_hits(p: int, gs: Sequence[int]) -> bool:
    """Classification: a purely multiplicative rule set hits iff some
    generator is divisible by `p`.  Multiplying by a unit fixes the valuation,
    so only a `p`-divisible generator can raise it."""
    return any(g % p == 0 for g in gs)


def additive_hits(p: int, e: int, cs: Sequence[int]) -> bool:
    """Classification: `{y -> y +- c_i}` reaches `x + dZ` with `d = gcd(c_i)`,
    which meets `p^{e+1} Z` iff `gcd(d, p^{e+1})` divides `p^e`, i.e. iff
    `v_p(d) <= e`."""
    d = 0
    for c in cs:
        d = gcd(d, c)
    if d == 0:
        return False
    return v_p(d, p) <= e


def acts_trivially(p: int, e: int, moves: Sequence[Affine]) -> bool:
    """Do all moves induce the identity on `Z/p^{e+1}`?

    A never-hitting *additive* set has `v_p(gcd c_i) >= e+1`, so every `c_i` is
    `0 mod p^{e+1}` — the moves are invisible in the finite model and cannot
    contribute to any union.  This is why no emergence occurs there.
    """
    M = p ** (e + 1)
    return all(g % M == 1 % M and c % M == 0 for g, c in moves)


# ------------------------------------------------------------------ emergence

EMERGENT_P2: Tuple[Affine, Affine] = ((0, 1), (2, 2))
"""The minimal emergent pair: at `p = 2`, `e = 1`, in `Z/4`, `y -> 1` and
`y -> 2y+2` each never reach `0` from `2`, and together they do: `2 -> 1 -> 0`."""


if __name__ == "__main__":
    print("== the finite model decides hitting")
    for p in (3, 5):
        for e in (1, 2):
            for name, mv in (
                ("succ", additive([1])),
                ("x2", multiplicative([2])),
                ("succ+x2", additive([1]) + multiplicative([2])),
            ):
                print(f"   p={p} e={e} {name:8} hits={hits(p, e, mv)}")

    print("\n== pure families are classified")
    for p in (3, 5, 7):
        for gs in ((2,), (3,), (2, 3), (p,), (4, 9)):
            assert hits(p, 2, multiplicative(gs)) == multiplicative_hits(p, gs)
        print(f"   p={p}: multiplicative classification matches")
    for p in (3, 5):
        for e in (1, 2):
            for cs in ((1,), (p,), (p**2,), (p**3,), (p, 2)):
                assert hits(p, e, additive(cs)) == additive_hits(p, e, cs)
        print(f"   p={p}: additive classification matches")

    print("\n== no emergence inside the natural families")
    print("   a never-hitting additive rule is the identity mod p^(e+1):")
    for p in (3, 5):
        for e in (1, 2):
            mv = additive([p ** (e + 1)])
            print(f"      p={p} e={e}: hits={hits(p, e, mv)} "
                  f"trivial={acts_trivially(p, e, mv)}")

    print("\n== but emergence is real for general affine rules")
    m1, m2 = EMERGENT_P2
    print(f"   p=2 e=1 in Z/4:  {m1} alone hits={hits(2, 1, [m1])}, "
          f"{m2} alone hits={hits(2, 1, [m2])}, "
          f"union hits={hits(2, 1, [m1, m2])}")
    print(f"   path: {witness_path(2, 1, [m1, m2])}")
