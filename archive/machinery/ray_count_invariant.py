#!/usr/bin/env python3
"""A doubly exponential count needs an exact invariant, and here is one.

`notes/BINARY_RAY_RECURSION.md` (codex-formation) classifies the extreme rays of
the binary aligned cones and derives

    R_k = R_{k-1} + R_{k-1}^2,     R_1 = 2,

giving 2, 6, 42, 1806, and remarks that "at depth three, the theorem produces 42
rays without polyhedral enumeration".  I attacked the minimal-face lemma and the
ray theorem and broke neither.  What the note understates is its own reach, and
what it lacks is a way to check the recursion at depths no enumeration can
reach.

**The growth.**  `R_5 = 3,263,442` and `R_6 = 10,650,056,950,806`.  So the
recursion is not a convenience that saves an enumeration at depth three; past
depth four or five **it is the only access there is**, and no independent count
will ever confirm it.

**The identification.**  `R_k + 1` is Sylvester's sequence
(`s_1 = 2`, `s_{n+1} = s_n^2 - s_n + 1`) shifted by one: `R_k + 1 = s_{k+1}`,
verified for `k <= 6`.  Indeed `R_k + 1 = R_{k-1}^2 + R_{k-1} + 1` and with
`s = R + 1` that is exactly `s^2 - s + 1`.

Two consequences follow, both classical for Sylvester and neither in the note.

**Theorem S1 (pairwise coprimality).**  The `R_k + 1` are pairwise coprime,
since `s_{n+1} = s_n(s_n - 1) + 1 == 1 (mod s_m)` for every `m <= n`.

**Theorem S2 (exact partial sum, with its error term).**

    sum_{k=1}^{K} 1/(R_k + 1)  =  1/2 - 1/R_{K+1}      exactly, for every K.

*Proof.*  `s_{n+1} - 1 = s_n(s_n - 1)`, so
`1/(s_n - 1) - 1/(s_{n+1} - 1) = 1/s_n` and the sum telescopes.  In this
indexing `s_{k+1} = R_k + 1` and `s_n - 1 = R_{n-1}`, giving the displayed
identity.  []

**Why S2 is the useful one.**  It is an exact finite identity, not a limit, and
its error term is `1/R_{K+1}` — so it is a *checkable invariant* for a sequence
far too large to enumerate.  Any implementation of the recursion must satisfy it
at every `K`.  It catches a wrong base case, a wrong coefficient, and an
off-by-one in the recursion, each of which reproduces plausible-looking numbers
otherwise.  For a doubly exponential count that is the only kind of check
available.
"""

from __future__ import annotations

from fractions import Fraction
from math import gcd


def ray_count(depth: int, base: int = 2, step=None) -> int:
    """`R_k` from `BINARY_RAY_RECURSION`: `R_k = R_{k-1} + R_{k-1}^2`, `R_1 = 2`.

    `base` and `step` are exposed so the invariant below can be shown to catch
    corrupted variants rather than merely to hold on the correct one.
    """
    if depth < 1:
        raise ValueError("depth starts at one")
    if step is None:
        def step(previous):
            return previous + previous * previous
    value = base
    for _ in range(depth - 1):
        value = step(value)
    return value


def sylvester(index: int) -> int:
    """`s_1 = 2`, `s_{n+1} = s_n^2 - s_n + 1`."""
    value = 2
    for _ in range(index - 1):
        value = value * value - value + 1
    return value


def is_sylvester_shift(depth: int) -> bool:
    """`R_k + 1 = s_{k+1}`."""
    return ray_count(depth) + 1 == sylvester(depth + 1)


def partial_sum(limit: int, base: int = 2, step=None) -> Fraction:
    return sum((Fraction(1, ray_count(k, base, step) + 1)
                for k in range(1, limit + 1)), Fraction(0))


def closed_form(limit: int, base: int = 2, step=None) -> Fraction:
    """Theorem S2's right-hand side: `1/2 - 1/R_{K+1}`."""
    return Fraction(1, 2) - Fraction(1, ray_count(limit + 1, base, step))


def invariant_holds(limit: int, base: int = 2, step=None) -> bool:
    """The checkable invariant. Must hold at every `K` for the true recursion."""
    return partial_sum(limit, base, step) == closed_form(limit, base, step)


def pairwise_coprime(depths) -> bool:
    values = [ray_count(k) + 1 for k in depths]
    return all(gcd(a, b) == 1
               for i, a in enumerate(values) for b in values[i + 1:])


def main() -> None:
    print("BINARY_RAY_RECURSION's counts, and how fast they leave enumeration\n")
    for depth in range(1, 8):
        print(f"  R_{depth} = {ray_count(depth):,}")
    print("\n  past depth four or five the recursion is the only access there is.")

    print("\nR_k + 1 is Sylvester's sequence shifted:")
    print(f"  Sylvester s_2..s_7 : {[sylvester(n) for n in range(2, 8)]}")
    print(f"  R_1..R_6 plus one  : {[ray_count(k) + 1 for k in range(1, 7)]}")
    print(f"  agree: {all(is_sylvester_shift(k) for k in range(1, 7))}")
    print(f"  pairwise coprime (Theorem S1): {pairwise_coprime(range(1, 7))}")

    print("\nTheorem S2:  sum_{k<=K} 1/(R_k+1) = 1/2 - 1/R_{K+1}, exactly")
    for limit in range(1, 5):
        print(f"  K={limit}: {partial_sum(limit)}  ==  {closed_form(limit)}"
              f"   {invariant_holds(limit)}")

    print("\nand it is a real test -- corrupted recursions are caught at K=4:")
    variants = (
        ("correct", 2, None),
        ("base R_1 = 3", 3, None),
        ("coefficient r + 2r^2", 2, lambda r: r + 2 * r * r),
        ("off by one r^2", 2, lambda r: r * r),
    )
    for name, base, step in variants:
        verdict = "PASS" if invariant_holds(4, base, step) else "CAUGHT"
        print(f"  {name:22} {verdict}")


if __name__ == "__main__":
    main()
