#!/usr/bin/env python3
"""The depth staircase is planted by the encounter order, and tau is exponential.

`notes/LEARNING_RAISES_DEPTH.md` exhibits a world growing one point at a time
whose chart depth climbs `0, 1, ..., E+1` -- one digit per encounter -- and
concludes that no bound depending on degree, dimension, or world size forces
uniform stabilization.  `notes/WITNESS_BASIS_STABILIZATION.md` then proves that
a single critical witness stabilizes the depth at time `tau`, and lists
cofiniteness, syndeticity, and mixing as "possible sufficient sources" of a
bound `H >= tau`.

Two things follow, both proved in `notes/ENCOUNTER_ORDER_DEPTH.md`:

* **Theorem S.**  In the canonical encounter order `S_t = {1,...,t}`, the depth
  of `x = p^E` is exactly `min(floor(log_p t), E+1)`.  The staircase does not
  occur: the depth sits at `E` for the whole range `p^E <= t < p^(E+1)` and
  then jumps once, to `E+1`, at `t = p^(E+1)`.  The `E`-step staircase is an
  artifact of an adversarially ordered curriculum.

* **Theorem O.**  `tau` is a function of the *filtration*, not of the world.
  With `S_infinity = Z_{>0}` fixed -- maximally cofinite, syndetic and mixing --
  `tau` is `p^D` in the canonical order and exceeds any prescribed `N` in
  another.  Hence no property of `S_infinity` can supply `H`; and even the most
  regular order pays `tau = p^D`, exponential in the stabilized depth.

Everything is exact.  `relative_depth` is a literal evaluation of the note's
own definition, not a formula.
"""

from __future__ import annotations

from typing import Iterable


def valuation(number: int, prime: int) -> int:
    """v_p, with v_p(0) a sentinel above any finite depth in use."""
    if number == 0:
        return 1 << 30
    height = 0
    while number % prime == 0:
        number //= prime
        height += 1
    return height


def relative_depth(world: Iterable[int], point: int, prime: int,
                   cap: int = 64) -> int:
    """`D_S(x)`: least k with v_p constant on `S` intersect the depth-k fiber.

    This is `LEARNING_RAISES_DEPTH`'s definition evaluated literally.
    """
    members = list(world)
    if point not in members:
        raise ValueError("the point must belong to its own world")
    for depth in range(cap):
        modulus = prime ** depth
        seen = {valuation(y, prime) for y in members if (y - point) % modulus == 0}
        if len(seen) == 1:
            return depth
    raise ValueError("no chart in range determines the valuation")


def staircase_world(prime: int, height: int, stage: int) -> list[int]:
    """`S_k` of the note's staircase: x = p^E adjoined with k adversaries."""
    if not 0 <= stage <= height + 1:
        raise ValueError("stage outside the staircase")
    point = prime ** height
    adversaries = [point + prime ** (j - 1) for j in range(1, height + 1)]
    adversaries.append(prime ** (height + 1))
    return [point] + adversaries[:stage]


def canonical_depth(prime: int, height: int, time: int) -> int:
    """Theorem S: `min(floor(log_p t), E+1)` for `t >= p^E`.

    Proof.  Put `x = p^E`, `S_t = {1,...,t}`, `t >= p^E`.
    (a) Depth `E+1` always suffices: `y = x + p^(E+1)m = p^E(u + pm)` with `u`
        a unit, so `v_p(y) = E`.
    (b) Every depth `k <= E-1` fails: `p^k` lies in the depth-k fiber of `x`
        (both are `0 mod p^k`), `p^k <= p^E <= t`, and `v_p(p^k) = k != E`.
    (c) If `p^E <= t < p^(E+1)`, depth `E` succeeds: the fiber is
        `{m p^E : 1 <= m <= floor(t/p^E)}` with `floor(t/p^E) <= p-1`, so no `m`
        is divisible by `p` and every member has valuation exactly `E`.
    (d) If `t >= p^(E+1)`, depth `E` fails: `p^(E+1)` is in the depth-E fiber
        and has valuation `E+1`.
    Together `D = E` on `[p^E, p^(E+1))` and `E+1` beyond, which is
    `min(floor(log_p t), E+1)`.  []
    """
    if time < prime ** height:
        raise ValueError("the point has not been encountered yet")
    logarithm = 0
    while prime ** (logarithm + 1) <= time:
        logarithm += 1
    return min(logarithm, height + 1)


def critical_witnesses(prime: int, height: int) -> str:
    """`W_D(x)` for `x = p^E`: exactly the multiples of `p^(E+1)`.

    `y = x + p^E m = p^E(1 + m)` has `v_p(y) != E` iff `p | 1 + m`, i.e. iff
    `p^(E+1)` divides `y`.  The stabilizing witness is therefore the first
    multiple of `p^(E+1)` the world encounters -- `p^(E+1)` itself, in the
    canonical order.
    """
    return f"multiples of {prime}^{height + 1} = {prime ** (height + 1)}"


def stabilization_time_canonical(prime: int, height: int) -> int:
    """Theorem O, positive half: `tau = p^(E+1) = p^D` in the canonical order."""
    return prime ** (height + 1)


def deferred_filtration(prime: int, height: int, delay: int) -> list[int]:
    """A filtration of the SAME `S_infinity` whose `tau` exceeds `delay`.

    Lists `delay` non-witnesses before admitting one.  Since the non-witnesses
    are infinite, `tau` is unbounded over filtrations of a fixed world; so no
    property of the world alone can bound it.
    """
    modulus = prime ** (height + 1)
    prefix, candidate = [], 1
    while len(prefix) < delay:
        if candidate % modulus:
            prefix.append(candidate)
        candidate += 1
    if prime ** height not in prefix:
        prefix.append(prime ** height)
    return prefix + [modulus]


def main() -> None:
    print("Theorem S -- canonical order S_t = {1,...,t}, x = p^E\n")
    print("  p  E    t range          depth   (staircase would give)")
    for prime, height in ((2, 3), (3, 2), (5, 2)):
        low, high = prime ** height, prime ** (height + 1)
        print(f"  {prime}  {height}    [{low}, {high})".ljust(24)
              + f"{canonical_depth(prime, height, low):^7}"
              + f"   0,1,...,{height} over {height + 1} encounters")
        print(f"  {prime}  {height}    [{high}, inf)".ljust(24)
              + f"{canonical_depth(prime, height, high):^7}"
              + f"   {height + 1}")
        print(f"        witnesses: {critical_witnesses(prime, height)};"
              f"  tau = {stabilization_time_canonical(prime, height)}"
              f" = p^D\n")
    print("Theorem O -- same world Z_{>0}, different order, unbounded tau")
    for delay in (10, 100, 1000):
        order = deferred_filtration(3, 2, delay)
        print(f"  deferred by {delay:>4}: tau = {len(order)}"
              f"   (canonical tau = {stabilization_time_canonical(3, 2)})")


if __name__ == "__main__":
    main()
