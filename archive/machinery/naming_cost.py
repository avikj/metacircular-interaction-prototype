"""Pricing a naming rule: the counting bound survives, the allocation varies.

Companion to `notes/NAMING_RULE_ACCOUNTING.md`.

I closed msg 0179 saying I would not build further on
`HYBRID_STORE_ACCOUNTING.md` Theorem U until I knew whether event-counting
survives contact with a **naming rule** -- a finite description generating many
elements, which every cost model in this thread charges wrongly because they all
charge per element formed.

It survives.  Price a name by its **length**, and

    a scheme with alphabet A gives at most A^L names of length <= L,

which is the same bound in the same shape as the chain counting bounds.  Nothing
about rules evades counting.  What a rule chooses is how to *spend* a bounded
name budget, and three attested systems spend it three different ways:

    positional base b   names = reach            TIGHT
    Aryabhata syllables names >> reach           REDUNDANT (buys metre)
    Archimedes orders   reach >> names           SPARSE   (buys reach)

All arithmetic exact.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from itertools import combinations_with_replacement
from collections import Counter


# ------------------------------------------------------- the counting bound

def name_bound(alphabet: int, length: int) -> int:
    """A^L: the most distinct names of length at most `length`.

    Theorem X.  Independent of what the scheme means by a symbol, so it applies
    to digits, syllables, myriad-numbers and chain steps alike.
    """
    if alphabet < 1 or length < 0:
        raise ValueError("require alphabet >= 1 and length >= 0")
    return alphabet ** length


def length_needed(alphabet: int, targets: int) -> int:
    """Least `L` with `A^L >= targets`: no scheme names more with fewer."""
    if alphabet < 2 or targets < 1:
        raise ValueError("require alphabet >= 2 and targets >= 1")
    length = 0
    while name_bound(alphabet, length) < targets:
        length += 1
    return length


# ------------------------------------------------------------ the schemes

@dataclass(frozen=True)
class Allocation:
    """How a scheme spends a bounded name budget."""

    scheme: str
    alphabet: int
    length: int
    names: int              # distinct names available
    log10_reach: float      # log10 of the largest nameable number
    kind: str               # 'tight' | 'redundant' | 'sparse'


def positional(base: int, length: int) -> Allocation:
    """Base-`base` place value: one name per integer below `base^length`."""
    if base < 2 or length < 1:
        raise ValueError("require base >= 2 and length >= 1")
    names = base ** length
    return Allocation("positional", base, length, names,
                      length * math.log10(base), "tight")


ARYABHATA_VARGA = tuple(range(1, 26))                       # ka..ma  = 1..25
ARYABHATA_AVARGA = (30, 40, 50, 60, 70, 80, 90, 100)        # ya..ha  = 30..100
ARYABHATA_PLACES = tuple(100 ** j for j in range(9))        # a..au = 10^0..10^16


def aryabhata_syllable_values() -> list[int]:
    """Every syllable value: consonant value times vowel place value.

    Gitikapada 2: varga consonants take 1..25, avarga 30..100, and the nine
    vowels denote the places 10^0, 10^2, ..., 10^16.  So `ka` is 1 and `hau`
    is 100 * 10^16 = 10^18.
    """
    consonants = list(ARYABHATA_VARGA) + list(ARYABHATA_AVARGA)
    return sorted({c * p for c in consonants for p in ARYABHATA_PLACES})


def aryabhata(length: int) -> Allocation:
    """Aryabhata's alphasyllabic scheme: syllable values add."""
    if length < 1:
        raise ValueError("length must be positive")
    values = aryabhata_syllable_values()
    alphabet = len(values)
    return Allocation("aryabhata", alphabet, length, alphabet ** length,
                      math.log10(length * max(values)), "redundant")


ARCHIMEDES_UNIT = 10 ** 8               # a myriad myriads
ARCHIMEDES_LOG10_REACH = 8 * 10 ** 16   # his largest named number, 10^(8*10^16)


def archimedes() -> Allocation:
    """Orders and periods: a name is (period, order, coefficient)."""
    return Allocation("archimedes", ARCHIMEDES_UNIT, 3, ARCHIMEDES_UNIT ** 3,
                      float(ARCHIMEDES_LOG10_REACH), "sparse")


# ------------------------------------------------------ measured redundancy

def aryabhata_multiset_counts(ceiling: int, syllables: int) -> Counter:
    """How many distinct syllable-multisets name each number up to `ceiling`.

    Exhaustive over multisets of at most `syllables` syllable values that stay
    within the ceiling, so the counts are exact.
    """
    if ceiling < 1 or syllables < 1:
        raise ValueError("require ceiling >= 1 and syllables >= 1")
    values = [v for v in aryabhata_syllable_values() if v <= ceiling]
    counts: Counter = Counter()
    for size in range(1, syllables + 1):
        for combo in combinations_with_replacement(values, size):
            total = sum(combo)
            if total <= ceiling:
                counts[total] += 1
    return counts


def redundancy(ceiling: int, syllables: int) -> tuple[int, float, int]:
    """(numbers covered, mean names per covered number, worst case)."""
    counts = aryabhata_multiset_counts(ceiling, syllables)
    covered = [n for n in range(1, ceiling + 1) if counts[n]]
    if not covered:
        return 0, 0.0, 0
    return (len(covered),
            sum(counts[n] for n in covered) / len(covered),
            max(counts[n] for n in covered))


if __name__ == "__main__":
    print("Theorem X: a scheme with alphabet A gives at most A^L names")
    print(f"  {'alphabet':>9} {'length':>7} {'names at most':>16}")
    for alphabet, length in ((10, 24), (60, 14), (289, 3), (10**8, 3)):
        print(f"  {alphabet:>9} {length:>7} "
              f"10^{math.log10(name_bound(alphabet, length)):<13.1f}")

    print()
    print("three attested schemes, three allocations of one bound")
    print(f"  {'scheme':>12} {'alphabet':>9} {'L':>3} {'names':>12} "
          f"{'reach':>14} {'kind':>10}")
    for allocation in (positional(10, 24), aryabhata(9), archimedes()):
        reach = (f"10^{allocation.log10_reach:.0f}"
                 if allocation.log10_reach < 10**6
                 else f"10^{allocation.log10_reach:.0e}")
        print(f"  {allocation.scheme:>12} {allocation.alphabet:>9} "
              f"{allocation.length:>3} "
              f"10^{math.log10(allocation.names):<9.1f} {reach:>14} "
              f"{allocation.kind:>10}")

    print()
    print("Aryabhata's redundancy, measured exhaustively")
    print(f"  {'ceiling':>8} {'syllables':>10} {'covered':>9} {'mean names':>11} "
          f"{'worst':>7}")
    for ceiling, syllables in ((100, 2), (300, 3), (300, 2)):
        covered, mean, worst = redundancy(ceiling, syllables)
        print(f"  {ceiling:>8} {syllables:>10} {covered:>4}/{ceiling:<4} "
              f"{mean:>11.1f} {worst:>7}")
    print("  every number is nameable, and most in many ways -- which is what")
    print("  gives the composer freedom to choose a word that scans.")
