"""How much memory buys: the held-set / step-count trade is a power law.

Companion to `notes/MEMORY_STEP_TRADEOFF.md`.

Answers the question I closed msg 0176 with, and asked whether it was a
threshold or a smooth trade:

    Theorem J bounds a FIXED free set.  The organism's held set GROWS.  At what
    growth rate of f(t) does the generic class become cheap?

It is a smooth power law with no threshold.  To reach *every* residue class
mod `M` within `n` operations from a held set `F`:

    necessity   |F| >~ M^(1/(2n))     (counting, Theorem N)
    sufficiency |F| <~ M^(1/n)        (positional reconstruction, Theorem P)

So constant-step access to arbitrary classes costs memory polynomial in `M` --
a positive power of the modulus, i.e. a table -- while memory polynomial in
`log M` leaves the generic floor at `c log M / log log M` exactly where
`MEMORY_NOT_SUBTRACTION.md` Theorem J put it.

The sufficiency construction is reconstruction from digits by nested
multiply-and-add.  See the note for the historical anchor and its boundary.
"""

from __future__ import annotations

import math
from dataclasses import dataclass


def reach_bound(held: int, steps: int) -> int:
    """At most this many integers are reachable in `steps` ops from `held`.

    At step i the chain holds `held + i - 1` entries, giving that many unordered
    pairs with repetition, times three operations (+, *, -).
    """
    if held < 1 or steps < 0:
        raise ValueError("require held >= 1 and steps >= 0")
    total = 1
    for i in range(1, steps + 1):
        size = held + i - 1
        total *= 3 * size * (size + 1) // 2
    return total


def necessary_held(modulus: int, steps: int) -> int:
    """Least `held` for which `reach_bound` can cover `modulus` classes.

    Below this, at least `modulus - reach_bound` classes are unreachable in
    `steps` operations, whatever the held set contains.
    """
    if modulus < 2:
        return 1
    if steps < 1:
        return modulus
    low, high = 1, modulus
    while low < high:
        mid = (low + high) // 2
        if reach_bound(mid, steps) >= modulus:
            high = mid
        else:
            low = mid + 1
    return low


# ------------------------------------------------ the positional construction

def positional_base(modulus: int, digits: int) -> int:
    """The base B = ceil(M^(1/n)), so that n digits cover every class."""
    if modulus < 2 or digits < 1:
        raise ValueError("require modulus >= 2 and digits >= 1")
    base = max(2, round(modulus ** (1.0 / digits)))
    while base ** digits < modulus:
        base += 1
    while base > 2 and (base - 1) ** digits >= modulus:
        base -= 1
    return base


def horner_reconstruction(target: int, base: int, digits: int) -> list[tuple]:
    """Rebuild `target` from its base-`base` digits by nested multiply-add.

    Returns the operation trace: ('*', base) and ('+', digit) entries.  Every
    operand is either the running accumulator, the base, or a digit -- all of
    which lie in the held set {0, 1, ..., base}.
    """
    if target < 0 or base < 2 or digits < 1:
        raise ValueError("require target >= 0, base >= 2, digits >= 1")
    limbs = []
    remainder = target
    for _ in range(digits):
        limbs.append(remainder % base)
        remainder //= base
    if remainder:
        raise ValueError(f"{digits} base-{base} digits cannot hold {target}")
    limbs.reverse()
    trace: list[tuple] = []
    accumulator = limbs[0]
    for limb in limbs[1:]:
        accumulator *= base
        trace.append(("*", base))
        if limb:
            accumulator += limb
            trace.append(("+", limb))
    if accumulator != target:
        raise AssertionError("reconstruction did not return the target")
    return trace


def worst_case_steps(modulus: int, digits: int) -> int:
    """Exact worst case over all classes, for the held set {0..B}."""
    base = positional_base(modulus, digits)
    return max(len(horner_reconstruction(c, base, digits))
               for c in range(modulus))


@dataclass(frozen=True)
class Tradeoff:
    """Held-set size against step count, both bounds, for one (M, n)."""

    modulus: int
    steps: int
    necessary: int          # counting lower bound on |F|
    sufficient: int         # |{0..B}| = B + 1
    achieved_steps: int     # exact worst case of the construction
    step_bound: int         # 2n - 2


def tradeoff(modulus: int, digits: int, exact: bool = True) -> Tradeoff:
    """Both sides of the trade at `digits` positional places."""
    base = positional_base(modulus, digits)
    return Tradeoff(
        modulus=modulus,
        steps=digits,
        necessary=necessary_held(modulus, 2 * digits - 2 if digits > 1 else 1),
        sufficient=base + 1,
        achieved_steps=worst_case_steps(modulus, digits) if exact else -1,
        step_bound=2 * digits - 2,
    )


if __name__ == "__main__":
    print("reaching EVERY class mod M: held-set size against operations")
    print(f"  {'M':>10} {'digits n':>9} {'held {0..B}':>12} {'steps used':>11} "
          f"{'2n-2':>6} {'counting needs >=':>18}")
    for modulus in (3**8, 5**6, 2**20):
        for digits in (2, 3, 4, 5):
            t = tradeoff(modulus, digits)
            print(f"  {t.modulus:>10} {t.steps:>9} {t.sufficient:>12} "
                  f"{t.achieved_steps:>11} {t.step_bound:>6} {t.necessary:>18}")

    print()
    print("the exponent: |F| between M^(1/2n) and M^(1/n)")
    print(f"  {'M':>14} {'n':>3} {'M^(1/2n)':>12} {'M^(1/n)':>12} "
          f"{'counting needs':>15}")
    for modulus in (10**12, 10**24):
        for n in (2, 3, 6):
            need = necessary_held(modulus, 2 * n - 2 if n > 1 else 1)
            print(f"  {modulus:>14} {n:>3} {modulus**(1/(2*n)):>12.0f} "
                  f"{modulus**(1/n):>12.0f} {need:>15}")

    print()
    print("memory polynomial in log M leaves the generic floor untouched:")
    for modulus in (3**160, 3**640):
        for held in (2, 100, 10**4):
            n = 1
            while reach_bound(held, n) < modulus:
                n += 1
            print(f"  M=3^{int(math.log(modulus, 3)):<4} held={held:<7} "
                  f"generic floor = {n} operations")
