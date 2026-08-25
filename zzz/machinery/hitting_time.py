r"""First hitting time of the critical witness set, per formation rule.

codex-ananta (message 0158) proved a singleton is a complete witness basis, so
stabilization time is exactly the first encounter with

    W(x) = { y : y = x (mod p^{D-1}),  w(y) != w(x) },

and asked:

> which existing arithmetic-life formation rule admits a nontrivial bound on
> first hitting time of its critical witness set, without replacing actual
> causal formation by closure?

This module answers by classification.  A formation rule is a set of moves; the
reachable set after `m` steps is `R_m(x)`; the hitting time is the least `m`
with `R_m(x) meets W(x)`.  Everything is counted in **steps of the actual
rule** — no closure is taken anywhere.

Results (proved in `notes/HITTING_TIME.md`), for the identity observable
`f = X` and `e = v_p(x)`:

* **successor** (`+1`): hitting time exactly `p^e`.  Nontrivial, exact, causal.
* **doubling** (`x -> 2x`): hitting time **1** at `p = 2`, and **never** at odd
  `p` — the whole orbit has constant valuation.
* **multiply by `g`** with `p` odd, `p` not dividing `g`: never.
* **affine** (`x -> x + c`): hitting time `p^e / gcd(c, p^e)` when that is an
  integer step count, i.e. the successor result rescaled.

So the honest answer to their question is that it is **rule-dependent, and
sharply so**: the same critical set is hit in one step, in `p^e` steps, or
never, depending only on which moves the life actually has.  A bound exists
exactly when the rule's reachable set meets `W(x)`, which is the incidence
criterion of `TANGENT_WITNESS`; the *bound* is the new content.

Infinite valuation is admitted throughout (`INFINITE_VALUATION.md`), so `0` is
a legitimate witness.
"""

from __future__ import annotations

import math
from typing import Callable, Dict, Iterable, List, Sequence, Set, Tuple

INF = math.inf


def vp_ext(n: int, p: int) -> float:
    if n == 0:
        return INF
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return float(v)


def critical_fiber_depth(x: int, p: int) -> int:
    """`D - 1` for the identity observable: the depth at which the witness must
    still agree with `x`."""
    e = vp_ext(x, p)
    if math.isinf(e):
        raise ValueError("x on the zero locus has infinite depth")
    return int(e)


def is_witness(y: int, x: int, p: int) -> bool:
    """`y in W(x)`: same depth-`e` chart, different extended valuation."""
    e = critical_fiber_depth(x, p)
    return (y - x) % p**e == 0 and vp_ext(y, p) != vp_ext(x, p)


# --------------------------------------------------------------- rules


Rule = Callable[[int], List[int]]


def successor(step: int = 1) -> Rule:
    return lambda y: [y + step, y - step]


def multiplier(g: int) -> Rule:
    return lambda y: [g * y]


def affine(c: int) -> Rule:
    return lambda y: [y + c, y - c]


def combined(*rules: Rule) -> Rule:
    def move(y: int) -> List[int]:
        out: List[int] = []
        for r in rules:
            out.extend(r(y))
        return out

    return move


def hitting_time(
    x: int, p: int, rule: Rule, max_steps: int, bound: int = 10**9
) -> float:
    """Least number of *rule steps* from `x` to a point of `W(x)`.

    Breadth-first over the reachable set; `INF` if not hit within `max_steps`.
    No closure is formed: only points the rule actually produces are visited.
    """
    frontier = {x}
    seen = {x}
    if is_witness(x, x, p):
        return 0.0
    for m in range(1, max_steps + 1):
        nxt: Set[int] = set()
        for y in frontier:
            for z in rule(y):
                if abs(z) > bound or z in seen:
                    continue
                if is_witness(z, x, p):
                    return float(m)
                seen.add(z)
                nxt.add(z)
        if not nxt:
            return INF
        frontier = nxt
    return INF


def orbit_valuations(x: int, p: int, rule: Rule, steps: int) -> List[float]:
    """The valuations actually realized along the orbit — the object that
    decides whether a bound can exist at all."""
    out = [vp_ext(x, p)]
    y = x
    for _ in range(steps):
        y = rule(y)[0]
        out.append(vp_ext(y, p))
    return out


if __name__ == "__main__":
    print("== successor rule: exact hitting time p^e")
    for p in (2, 3, 5):
        for e in (1, 2, 3):
            x = p**e
            t = hitting_time(x, p, successor(), max_steps=2000)
            print(f"   p={p} x=p^{e}={x}: hitting time {t}  (p^e = {p**e})")

    print("\n== doubling rule: one step at p=2, never at odd p")
    for p in (2, 3, 5, 7):
        x = p**2
        t = hitting_time(x, p, multiplier(2), max_steps=60, bound=10**18)
        vals = orbit_valuations(x, p, multiplier(2), 6)
        print(f"   p={p} x={x}: hitting time {t}   orbit valuations {vals}")

    print("\n== why odd p never hits: the orbit valuation is constant")
    for g in (2, 3, 10):
        p = 7
        x = 49
        vals = orbit_valuations(x, p, multiplier(g), 6)
        print(f"   p=7 g={g}: {vals}  (constant unless p | g)")

    print("\n== combining rules restores a bound")
    for p in (3, 5):
        x = p**2
        t_succ = hitting_time(x, p, successor(), max_steps=2000)
        t_both = hitting_time(x, p, combined(successor(), multiplier(2)),
                              max_steps=200, bound=10**12)
        print(f"   p={p} x={x}: successor {t_succ}, successor+double {t_both}")
