"""Pricing the decode as well as the name: the trade is real only for digits.

Companion to `notes/DECODE_COST.md`.

I closed msg 0180 asking whether the pair (name length, decode length) is a
genuine trade or whether one allocation dominates both coordinates -- and said
that if sparse schemes are dear to decode by exactly what they save in naming,
the whole thread collapses to a single conserved quantity.

It does not collapse.  The answer depends on what "having the number" means, and
the two readings give opposite answers:

  * **canonical decoding** -- produce the base-`b` digits.  Then
    `name + decode >= number of digits = Theta(log n)` for every scheme, because
    the *output* has that many symbols.  Archimedes' naming saving is exactly
    repaid.  The conservation is real and completely uninformative: it says only
    that you must write the answer down.

  * **value decoding** -- hold the number as a constructed arithmetic value.
    Then structured numbers are cheap in **both** coordinates and generic
    numbers are dear in both.  No trade; the same structured/generic split
    again, now as a statement about the pair.

The Egyptian doubling method is the worked historical instance of the first:
the scribe pays `log n` in the table and `log n` in the selection.

All arithmetic exact.
"""

from __future__ import annotations

import math
from dataclasses import dataclass


# --------------------------------------------------------- the two decodes

def digit_count(value: int, base: int = 10) -> int:
    """Symbols in the canonical representation -- the output-size floor."""
    if value < 0 or base < 2:
        raise ValueError("require value >= 0 and base >= 2")
    if value == 0:
        return 1
    return len(str(value)) if base == 10 else int(math.log(value, base)) + 1


def horner_decode_cost(digits: int) -> int:
    """Operations to rebuild a value from `digits` positional digits.

    `MEMORY_STEP_TRADEOFF.md` Theorem P: `2n-2` for `n` digits.
    """
    if digits < 1:
        raise ValueError("digits must be positive")
    return max(0, 2 * digits - 2)


def power_decode_cost(exponent: int) -> int:
    """Multiplications to build `p^exponent` by square-and-multiply."""
    if exponent < 1:
        raise ValueError("exponent must be positive")
    return (exponent.bit_length() - 1) + bin(exponent).count("1") - 1


@dataclass(frozen=True)
class CostPair:
    """What a scheme charges to name a number and then to have it."""

    scheme: str
    log10_value: float
    name_length: int
    canonical_decode: int      # symbols of output, the Theorem AA floor
    value_decode: int          # chain operations to build it arithmetically
    total_canonical: int


def positional_pair(digits: int, base: int = 10) -> CostPair:
    """A generic number written positionally: both coordinates are log n."""
    if digits < 1:
        raise ValueError("digits must be positive")
    return CostPair(
        scheme=f"positional base {base}",
        log10_value=digits * math.log10(base),
        name_length=digits,
        canonical_decode=digits,
        value_decode=horner_decode_cost(digits),
        total_canonical=digits + digits,
    )


def structured_pair(p: int, k: int) -> CostPair:
    """The structured number `p^(2^k)`: short name, short chain, vast digits."""
    if p < 2 or k < 0:
        raise ValueError("require p >= 2 and k >= 0")
    exponent = 2 ** k
    log10_value = exponent * math.log10(p)
    return CostPair(
        scheme=f"{p}^(2^{k}) named by its exponent",
        log10_value=log10_value,
        name_length=max(1, k.bit_length()),          # name the exponent's index
        canonical_decode=int(log10_value) + 1,       # every digit of the value
        value_decode=power_decode_cost(exponent),    # k squarings
        total_canonical=max(1, k.bit_length()) + int(log10_value) + 1,
    )


# ------------------------------------------------- the Egyptian instance

def egyptian_table(multiplicand: int, multiplier: int) -> list[tuple[int, int]]:
    """The Rhind doubling table: (power of two, multiplicand times it)."""
    if multiplicand < 1 or multiplier < 1:
        raise ValueError("both factors must be positive")
    rows = []
    power, doubled = 1, multiplicand
    while power <= multiplier:
        rows.append((power, doubled))
        power *= 2
        doubled *= 2
    return rows


def egyptian_selection(multiplier: int) -> list[int]:
    """The powers of two kept -- exactly the set bits of the multiplier."""
    if multiplier < 1:
        raise ValueError("multiplier must be positive")
    return [1 << i for i in range(multiplier.bit_length())
            if multiplier >> i & 1]


def egyptian_product(multiplicand: int, multiplier: int) -> tuple[int, int, int]:
    """(product, table rows written, additions performed).

    The table is the 'name' -- one row per binary place of the multiplier --
    and the selection-and-sum is the 'decode'.  Both are `Theta(log n)`.
    """
    rows = dict(egyptian_table(multiplicand, multiplier))
    kept = egyptian_selection(multiplier)
    product = sum(rows[power] for power in kept)
    if product != multiplicand * multiplier:
        raise AssertionError("doubling method disagreed with the product")
    return product, len(rows), max(0, len(kept) - 1)


if __name__ == "__main__":
    print("Theorem AA: under canonical decoding the total is the output size")
    print(f"  {'scheme':>34} {'log10 value':>12} {'name':>6} "
          f"{'decode':>10} {'total':>10}")
    for pair in (positional_pair(24), positional_pair(100),
                 structured_pair(3, 6), structured_pair(3, 16)):
        print(f"  {pair.scheme:>34} {pair.log10_value:>12.0f} "
              f"{pair.name_length:>6} {pair.canonical_decode:>10} "
              f"{pair.total_canonical:>10}")
    print("  the structured name is tiny and its canonical decode is the whole")
    print("  digit string: the saving is repaid exactly, because you must")
    print("  write the answer down.")

    print()
    print("Theorem BB: under value decoding there is no trade")
    print(f"  {'scheme':>34} {'name':>6} {'chain':>7} {'log10 value':>12}")
    for pair in (positional_pair(24), structured_pair(3, 6),
                 structured_pair(3, 16), structured_pair(3, 64)):
        print(f"  {pair.scheme:>34} {pair.name_length:>6} "
              f"{pair.value_decode:>7} {pair.log10_value:>12.0f}")
    print("  structured numbers are cheap in BOTH coordinates; a generic")
    print("  number of the same magnitude is dear in both.")

    print()
    print("the Rhind instance: 13 x 23, both coordinates logarithmic")
    product, rows, adds = egyptian_product(23, 13)
    print(f"  table: {egyptian_table(23, 13)}")
    print(f"  13 = {' + '.join(str(x) for x in egyptian_selection(13))}")
    print(f"  product {product}, {rows} rows written, {adds} additions")
