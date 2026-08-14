"""A formed locus is memory the organism cannot spend as digits.

Companion to `notes/LOCUS_MEMORY_FAMINE.md`.

`MEMORY_STEP_TRADEOFF.md` Theorem P holds an **interval** `{0..B}` and reaches
every residue class mod `M` in `2n-2` operations by positional reconstruction.
The organism does not hold an interval.  It holds what it **formed**, which is a
multiplicative locus `F = {prod p_i^{e_i}}` -- and a locus of the same
cardinality is a completely different object:

  * **sparsity** (Theorem R): a locus on `k` primes has at most
    `prod (1 + log X / log p_i)` elements below `X`, so `f` elements require
    reach `X >= exp((f^{1/k} - 1) log 2)` -- the elements are exponentially
    spread out, not consecutive;
  * **digit famine** (Theorem S): of the `B` digits a base-`B` reconstruction
    needs, the locus supplies `O((log B)^k)`;
  * **sum representation** (Theorem T): representing classes as bounded sums of
    held elements needs `C(f+t, t) >= M`, so a polylogarithmic locus buys
    nothing at all.

The Old Babylonian reciprocal table is exactly such a locus -- the regular
numbers, `2,3,5`-smooth -- which makes the historical instance computable rather
than analogical.

All arithmetic exact.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Sequence


def locus(primes: Sequence[int], ceiling: int) -> list[int]:
    """Every product of the given primes that is at most `ceiling`."""
    if ceiling < 1:
        raise ValueError("ceiling must be positive")
    for p in primes:
        if p < 2:
            raise ValueError(f"{p} is not a valid generator")
    reached = {1}
    for p in primes:
        grown = set()
        for value in reached:
            power = value
            while power <= ceiling:
                grown.add(power)
                power *= p
        reached = grown
    return sorted(reached)


def sparsity_bound(primes: Sequence[int], ceiling: int) -> float:
    """prod (1 + log X / log p): an exact upper bound on the locus size.

    Each exponent `e_i` satisfies `p_i^{e_i} <= X`, so it takes at most
    `1 + log X / log p_i` values, and the locus injects into that product.
    """
    if ceiling < 1:
        raise ValueError("ceiling must be positive")
    total = 1.0
    for p in primes:
        total *= 1 + math.log(ceiling) / math.log(p)
    return total


def required_reach(size: int, generators: int) -> float:
    """Least `log X` for a locus on `generators` primes to hold `size` elements.

    From `size <= (1 + log X / log 2)^k`, so `log X >= (size^{1/k} - 1) log 2`.
    """
    if size < 1 or generators < 1:
        raise ValueError("require size >= 1 and generators >= 1")
    return (size ** (1.0 / generators) - 1) * math.log(2)


def digit_coverage(primes: Sequence[int], base: int) -> tuple[int, int]:
    """(digits the locus supplies, digits a base-`base` reconstruction needs)."""
    if base < 2:
        raise ValueError("base must be at least 2")
    supplied = len([x for x in locus(primes, base - 1) if x < base])
    return supplied, base


def sum_representation_bound(held: int, terms: int) -> int:
    """Values representable as a sum of at most `terms` held elements.

    Multisets of size at most `terms` drawn from `held` elements number
    `C(held + terms, terms)`.
    """
    if held < 1 or terms < 0:
        raise ValueError("require held >= 1 and terms >= 0")
    return math.comb(held + terms, terms)


def terms_needed(modulus: int, held: int) -> int:
    """Least `t` with `C(held+t, t) >= modulus`; below it classes are missed.

    Binary search, since `t` can be large when `held` is small relative to the
    modulus -- which is exactly the regime this theorem is about.
    """
    if modulus < 2:
        return 0
    if held < 1:
        raise ValueError("held must be positive")
    low, high = 0, 1
    while sum_representation_bound(held, high) < modulus:
        high *= 2
    while low < high:
        mid = (low + high) // 2
        if sum_representation_bound(held, mid) >= modulus:
            high = mid
        else:
            low = mid + 1
    return low


@dataclass(frozen=True)
class LocusVerdict:
    """How a formed locus compares with an interval of the same size."""

    generators: tuple
    ceiling: int
    size: int
    interval_of_same_size_reaches: int      # {0..f-1} tops out at f-1
    locus_reaches: int                      # the largest held element
    digits_supplied: int
    digits_needed: int


def compare_with_interval(primes: Sequence[int], ceiling: int,
                          base: int) -> LocusVerdict:
    """The two ways a locus differs from an interval of equal cardinality."""
    held = locus(primes, ceiling)
    supplied, needed = digit_coverage(primes, base)
    return LocusVerdict(
        generators=tuple(primes),
        ceiling=ceiling,
        size=len(held),
        interval_of_same_size_reaches=len(held) - 1,
        locus_reaches=held[-1],
        digits_supplied=supplied,
        digits_needed=needed,
    )


# ------------------------------------------------- the Babylonian instance

BABYLONIAN_GENERATORS = (2, 3, 5)
BABYLONIAN_TABLE_CEILING = 81      # the standard Old Babylonian range
SEXAGESIMAL_BASE = 60


def babylonian_table() -> list[int]:
    """The regular numbers up to 81 -- the standard reciprocal table's range."""
    return locus(BABYLONIAN_GENERATORS, BABYLONIAN_TABLE_CEILING)


if __name__ == "__main__":
    print("Theorem R: a locus is polylogarithmically sparse")
    print(f"  {'primes':>12} {'X':>8} {'|F|':>6} {'bound':>10}")
    for primes in ((2, 3), (2, 3, 5), (2, 3, 5, 7)):
        for exponent in (3, 6, 9):
            ceiling = 10 ** exponent
            print(f"  {str(primes):>12} {'10^' + str(exponent):>8} "
                  f"{len(locus(primes, ceiling)):>6} "
                  f"{sparsity_bound(primes, ceiling):>10.0f}")

    print()
    print("so a locus of size f must reach exponentially far")
    print(f"  {'f':>8} {'k':>3} {'log X at least':>16}")
    for size in (100, 10**4, 10**6):
        for k in (2, 3):
            print(f"  {size:>8} {k:>3} {required_reach(size, k):>16.1f}")

    print()
    print("Theorem S: digit famine")
    print(f"  {'primes':>12} {'base':>6} {'supplied':>9} {'needed':>7}")
    for primes in ((2, 3), (2, 3, 5)):
        for base in (16, 60, 256, 1024):
            supplied, needed = digit_coverage(primes, base)
            print(f"  {str(primes):>12} {base:>6} {supplied:>9} {needed:>7}")

    print()
    print("the Old Babylonian instance, exactly")
    table = babylonian_table()
    below = [x for x in table if x < SEXAGESIMAL_BASE]
    print(f"  regular numbers <= {BABYLONIAN_TABLE_CEILING}: {len(table)}")
    print(f"  {table}")
    print(f"  sexagesimal digits needed: {SEXAGESIMAL_BASE}; "
          f"supplied by the table: {len(below)}")

    print()
    print("Theorem T: bounded sums of a polylogarithmic locus buy nothing")
    print(f"  {'modulus':>10} {'held':>7} {'terms needed':>13}")
    for modulus, held in ((3**160, 100), (3**160, 10**4),
                          (3**640, 100), (3**640, 10**4)):
        print(f"  {'3^' + str(round(math.log(modulus, 3))):>10} {held:>7} "
              f"{terms_needed(modulus, held):>13}")
