"""One store can be both long and digit-dense: my dichotomy was an artefact.

Companion to `notes/HYBRID_STORE_ACCOUNTING.md`.

`LOCUS_MEMORY_FAMINE.md` §3 compared two pure held sets -- an interval (short,
digit-dense) and a multiplicative locus (long, digit-starved) -- and read a
dichotomy into the comparison: an organism wanting both must keep **two
stores**.  I closed msg 0178 asking whether that split was forced.

It is not.  Split a formation budget `f` into `alpha f` successor events and
`(1-alpha) f` multiplication events.  The resulting single held set is
digit-dense up to `alpha f` **and** reaches `exp(Theta(((1-alpha) f)^{1/k}))`.
There is no trade-off beyond the linear split, so §3's dichotomy is withdrawn
and msg 0178's reading of the Babylonian two-table practice is corrected: the
two stores are a division of labour, not an arithmetic necessity.

Archimedes' *Sand Reckoner* is the hybrid, deliberately constructed: an interval
alphabet (the myriad system, up to `10^8`) carrying a multiplicative tower of
orders `(10^8)^n` and then periods.  See the note for what that instance does
**not** translate.

All arithmetic exact.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Sequence

from locus_memory import locus


@dataclass(frozen=True)
class StoreProfile:
    """What a held set is worth: how far it reaches, how many digits it gives."""

    size: int
    reach: int              # the largest held element
    digits_supplied: int    # held elements below the base
    base: int
    events: int             # formation events spent
    alpha: float            # fraction of the budget spent on successor


def locus_of_size(primes: Sequence[int], count: int) -> list[int]:
    """The `count` smallest products of `primes`, by growing the ceiling."""
    if count < 1:
        raise ValueError("count must be positive")
    ceiling = 2
    while len(locus(primes, ceiling)) < count:
        ceiling *= 2
    return locus(primes, ceiling)[:count]


def hybrid_store(alpha: float, budget: int, primes: Sequence[int]
                 ) -> list[int]:
    """Spend `alpha` of the budget counting and the rest multiplying.

    The successor events build the interval `{0..alpha*budget}`; the
    multiplication events build the smallest that many products of `primes`.
    """
    if not 0.0 <= alpha <= 1.0:
        raise ValueError("alpha must lie in [0,1]")
    if budget < 1:
        raise ValueError("budget must be positive")
    counting = int(alpha * budget)
    multiplying = budget - counting
    held = set(range(counting + 1))
    if multiplying > 0:
        held |= set(locus_of_size(primes, multiplying))
    return sorted(held)


def profile(held: Sequence[int], base: int, events: int,
            alpha: float) -> StoreProfile:
    """Measure a held set against the two things a store can be worth."""
    if base < 2:
        raise ValueError("base must be at least 2")
    held = list(held)
    if not held:
        raise ValueError("held set is empty")
    return StoreProfile(
        size=len(held),
        reach=max(held),
        digits_supplied=len([x for x in held if x < base]),
        base=base,
        events=events,
        alpha=alpha,
    )


def hybrid_profile(alpha: float, budget: int, primes: Sequence[int],
                   base: int) -> StoreProfile:
    """The profile of the hybrid store at one budget split."""
    return profile(hybrid_store(alpha, budget, primes), base, budget, alpha)


def reach_lower_bound(multiplying: int, generators: int) -> float:
    """log of the reach a locus of that many elements must have.

    `LOCUS_MEMORY_FAMINE.md` Corollary R': `log X >= (f^{1/k} - 1) log 2`.
    """
    if multiplying < 1 or generators < 1:
        raise ValueError("require multiplying >= 1 and generators >= 1")
    return (multiplying ** (1.0 / generators) - 1) * math.log(2)


# ------------------------------------------------- the Archimedean instance

MYRIAD = 10 ** 4
MYRIAD_MYRIAD = MYRIAD ** 2          # 10^8, Archimedes' first-order ceiling


def archimedes_order_unit(order: int) -> int:
    """The unit of the `order`-th order: (10^8)^(order-1).

    First order runs up to 10^8; 10^8 is the unit of the second order, and so
    on.  Each successive unit is one multiplication from the previous.
    """
    if order < 1:
        raise ValueError("orders are numbered from 1")
    return MYRIAD_MYRIAD ** (order - 1)


def archimedes_tower(orders: int) -> list[int]:
    """The order units up to `orders`, one multiplication apart."""
    if orders < 1:
        raise ValueError("orders must be positive")
    return [archimedes_order_unit(i) for i in range(1, orders + 1)]


def archimedes_profile(orders: int, base: int = MYRIAD_MYRIAD) -> StoreProfile:
    """The Sand Reckoner as a hybrid store: myriad alphabet plus order tower.

    The alphabet is modelled as the interval `{0..10^4}` actually written with
    Greek alphabetic numerals; the tower is the multiplicative part.  See the
    note: Archimedes *names* his alphabet rather than storing it, which this
    model does not capture.
    """
    alphabet = list(range(MYRIAD + 1))
    tower = archimedes_tower(orders)
    held = sorted(set(alphabet) | set(tower))
    return profile(held, base, len(alphabet) + orders, 0.0)


if __name__ == "__main__":
    print("one store, both properties: budget 1000, primes (2,3), base 256")
    print(f"  {'alpha':>6} {'|H|':>6} {'reach':>14} {'digits/256':>11} "
          f"{'reach bound':>12}")
    for alpha in (0.0, 0.25, 0.5, 0.75, 1.0):
        p = hybrid_profile(alpha, 1000, (2, 3), 256)
        multiplying = 1000 - int(alpha * 1000)
        bound = (f"{reach_lower_bound(multiplying, 2):.1f}"
                 if multiplying else "-")
        reach = (str(p.reach) if p.reach < 10**12
                 else f"~10^{len(str(p.reach))-1}")
        print(f"  {alpha:>6} {p.size:>6} {reach:>14} {p.digits_supplied:>11} "
              f"{bound:>12}")

    print()
    print("the pure endpoints each fail one property; the middle fails neither")

    print()
    print("Archimedes' Sand Reckoner, as a hybrid store")
    print(f"  {'orders':>7} {'reach':>28} {'digits below 10^8':>18}")
    for orders in (1, 2, 3, 5, 9):
        p = archimedes_profile(orders)
        reach = (str(p.reach) if p.reach < 10**12
                 else f"~10^{len(str(p.reach))-1}")
        print(f"  {orders:>7} {reach:>28} {p.digits_supplied:>18}")
    print(f"  Archimedes' first period ends at (10^8)^(10^8) = "
          f"10^(8*10^8); his largest named number is 10^(8*10^16).")
