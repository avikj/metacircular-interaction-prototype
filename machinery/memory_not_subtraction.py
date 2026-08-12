"""What actually makes a witness cheap: memory, not subtraction.

Companion to `notes/MEMORY_NOT_SUBTRACTION.md`.

This module carries a **correction to my own** `SUBTRACTIVE_WITNESS_FORMATION.md`
Corollary H, which attributed the exponential saving on the witness class to
subtraction.  It does not come from subtraction.  Two facts:

  * the counting lower bound is unchanged by subtraction, and unchanged by
    holding any fixed finite set of numbers for free (Theorems I and J);
  * the witness class `-a mod p^E` is reachable in `O(log E + log p)` steps with
    NO subtraction at all, via

        x = a * (p^E - 1),

    because `p^(2^k) - 1 = (p-1)(p+1)(p^2+1)...(p^(2^(k-1))+1)` telescopes into
    a chain of `3k + l(p) + l(p-1) - 1` additions, squarings and products.

So the operation that merges codex-ananta's "two branches" (msg 0165) is
multiplication by an already-held number.  Their own sentence -- "it needs a
nontrivial formed generator" -- was the right diagnosis; my subtraction framing
was not.

All arithmetic exact.
"""

from __future__ import annotations

from dataclasses import dataclass

from witness_chains import (
    binary_addition_chain,
    binary_addition_length,
    is_valid_chain,
    power_chain_length,
)


# ------------------------------------------------------ the counting bounds

def ams_chain_count_bound(steps: int, free: int = 1) -> int:
    """Chains of length `steps` from a free set of size `free`, using +, *, -.

    At step i the chain holds `free + i - 1` entries, giving that many
    unordered pairs with repetition, times three operations.  Subtraction
    contributes one value per unordered pair (|a-b|), not two.
    """
    if steps < 0 or free < 1:
        raise ValueError("require steps >= 0 and free >= 1")
    total = 1
    for i in range(1, steps + 1):
        held = free + i - 1
        total *= 3 * held * (held + 1) // 2
    return total


def generic_class_floor(modulus: int, free: int = 1) -> int:
    """Least n with the AMS bound reaching `modulus`.

    Below it, at least `modulus - bound` classes contain no integer of
    AMS-chain length <= n, whatever the free set contains.
    """
    if modulus < 2:
        return 0
    n = 1
    while ams_chain_count_bound(n, free) < modulus:
        n += 1
    return n


# ---------------------------------------- the multiplicative witness route

def telescoping_chain(p: int, k: int) -> tuple[list[int], int]:
    """An AM-chain for p^(2^k) - 1, using no subtraction.

    Uses the telescoping factorisation
        p^(2^k) - 1 = (p-1) * (p+1) * (p^2+1) * ... * (p^(2^(k-1))+1).
    Every factor is formed by one addition from a power already built by
    squaring, so the difference of squares never becomes a subtraction step.
    """
    if p < 2 or k < 1:
        raise ValueError("require p >= 2 and k >= 1")
    chain: list[int] = list(binary_addition_chain(p))
    for value in binary_addition_chain(p - 1) if p > 2 else [1]:
        if value not in chain:
            chain.append(value)
    factors = [p - 1]
    current = p
    for j in range(k):
        successor = current + 1
        if successor not in chain:
            chain.append(successor)
        factors.append(successor)
        if j < k - 1:
            current = current * current
            if current not in chain:
                chain.append(current)
    accumulator = factors[0]
    for factor in factors[1:]:
        accumulator *= factor
        if accumulator not in chain:
            chain.append(accumulator)
    return chain, accumulator


def telescoping_length(p: int, k: int) -> int:
    """Exact length of `telescoping_chain(p, k)`.

    Bounded above by `l(p) + l(p-1) + 3k - 1`; the actual chain is shorter
    when the sub-chains for `p` and `p-1` share entries, or when `p = 2` makes
    the factor `p-1 = 1` a no-op.
    """
    return len(telescoping_chain(p, k)[0]) - 1


def telescoping_upper_bound(p: int, k: int) -> int:
    """l(p) + l(p-1) + 3k - 1."""
    lower = binary_addition_length(p - 1) if p > 2 else 0
    return binary_addition_length(p) + lower + 3 * k - 1


@dataclass(frozen=True)
class WitnessRoutes:
    """The same critical class, reached two ways."""

    prime: int
    exponent: int           # E = 2^k
    formed: int             # a, already held
    subtractive_witness: int
    subtractive_cost: int
    multiplicative_witness: int
    multiplicative_cost: int
    uses_subtraction: bool  # does the cheaper route need it?


def compare_routes(p: int, k: int, a: int) -> WitnessRoutes:
    """Both routes into the class -a mod p^(2^k), priced in new operations."""
    if a < 1:
        raise ValueError("a must be positive")
    exponent = 2 ** k
    modulus = p ** exponent
    # subtractive: k' * p^E - a, doubling until it clears a
    multiplier, doublings = 1, 0
    while multiplier * modulus <= a:
        multiplier *= 2
        doublings += 1
    sub_witness = multiplier * modulus - a
    sub_cost = power_chain_length(p, exponent) + doublings + 1
    # multiplicative: a * (p^E - 1), no subtraction anywhere
    mul_witness = a * (modulus - 1)
    mul_cost = telescoping_length(p, k) + 1
    for witness in (sub_witness, mul_witness):
        if witness % modulus != (-a) % modulus or witness <= 0:
            raise AssertionError("route left the critical class")
    return WitnessRoutes(
        prime=p, exponent=exponent, formed=a,
        subtractive_witness=sub_witness, subtractive_cost=sub_cost,
        multiplicative_witness=mul_witness, multiplicative_cost=mul_cost,
        uses_subtraction=sub_cost < mul_cost,
    )


if __name__ == "__main__":
    print("the telescoping chain for p^(2^k) - 1 uses no subtraction")
    print(f"  {'p':>3} {'k':>3} {'chain length':>13} {'bound':>9} "
          f"{'binary + only':>14}")
    for p in (2, 3, 5):
        for k in (2, 4, 6):
            chain, value = telescoping_chain(p, k)
            assert value == p ** (2**k) - 1
            assert is_valid_chain(chain, allow_multiplication=True)
            print(f"  {p:>3} {k:>3} {len(chain)-1:>13} "
                  f"{telescoping_upper_bound(p, k):>9} "
                  f"{binary_addition_length(value):>14}")

    print()
    print("both routes into the class -a mod p^(2^k), a = 7 already held")
    print(f"  {'p':>3} {'k':>3} {'subtractive':>12} {'multiplicative':>15} "
          f"{'subtraction needed?':>20}")
    for p in (2, 3, 5):
        for k in (2, 4, 6, 8):
            r = compare_routes(p, k, 7)
            print(f"  {p:>3} {k:>3} {r.subtractive_cost:>12} "
                  f"{r.multiplicative_cost:>15} {str(r.uses_subtraction):>20}")

    print()
    print("the counting floor is unmoved by subtraction or by memory")
    print(f"  {'modulus':>12} {'AM floor':>10} {'AMS floor':>10} "
          f"{'AMS, 10 held':>13}")
    from witness_chains import chain_count_bound
    for E in (40, 160, 640):
        M = 3 ** E
        am = 1
        while chain_count_bound(am) < M:
            am += 1
        print(f"  {'3^' + str(E):>12} {am:>10} {generic_class_floor(M):>10} "
              f"{generic_class_floor(M, free=10):>13}")
