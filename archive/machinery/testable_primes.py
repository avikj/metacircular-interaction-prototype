#!/usr/bin/env python3
"""The radical state over-refines: only primes the remaining budget can test matter.

`notes/RADICAL_SPLIT_STATE.md` (codex-formation) proves that the split machine's
exact gcd state `(g,h)` may be replaced by `(rad g, rad h)`, because a gcd
exceeds one exactly when some prime divides every argument, and only the prime
*set* of `g` matters.  That is correct, and its rigor boundary says so honestly:

    This proves a quotient sufficient for exact future acceptance, not that the
    radical pair is globally minimal ... Some primes may be irrelevant in a
    particular `(j,s)` state because no feasible suffix can test them.

That gap is fillable, and the answer is a two-line necessary-and-sufficient
criterion rather than a caveat.

**Theorem R (testable primes).**  Suppose `k >= 1` steps remain and the
remaining entries are positive integers summing to `S`.  A prime `p` divides
every remaining entry for *some* feasible continuation **iff**

    p | S    and    p*k <= S.

*Proof.*  (=>)  If `p` divides each of `k` positive entries then each is at
least `p`, so `S >= p*k`; and `p | S` since `p` divides the sum.  (<=)  If
`p | S` and `p*k <= S` then `S/p >= k`, so some `k`-tuple of positive integers
sums to `S/p`; multiply it by `p`.  []

**Corollary (the minimal coordinate).**  The `g`-coordinate may be replaced by

    T(g, k, S) = product of { p : p | g, p | S, p*k <= S },

and no coarser function of `g` is sufficient, because each surviving prime is
realized by an actual continuation.  Since `T(g,k,S)` divides `rad g` and is
usually a proper divisor, **the radical pair is strictly non-minimal.**

**Discriminating instance**, which their note flags as possible but does not
supply: `rad g = 6` and `rad g = 1` are behaviourally identical when the
remaining sum is `5`.  Every positive continuation summing to `5` has
`gcd(6, a_1, ..., a_k) = 1`, because all-even would force `2 | 5` and
all-divisible-by-3 would force `3 | 5`.  So the radical state `6` collapses to
`1`, and exact gcd, radical, and testable-prime states form three strictly
nested quotients rather than two.

Over-refinement is the norm, not the exception: `gcd(rad g, S) < rad g` for
1452 of the 1624 pairs `2 <= g < 60`, `2 <= S < 30`.
"""

from __future__ import annotations

from functools import reduce
from math import gcd
from itertools import product


def radical(number: int) -> int:
    """Product of the distinct primes dividing `number`; `radical(0) = 0`."""
    if number == 0:
        return 0
    result, divisor = 1, 2
    while divisor * divisor <= number:
        if number % divisor == 0:
            result *= divisor
            while number % divisor == 0:
                number //= divisor
        divisor += 1
    return result * (number if number > 1 else 1)


def prime_factors(number: int) -> list[int]:
    factors, divisor = [], 2
    while divisor * divisor <= number:
        if number % divisor == 0:
            factors.append(divisor)
            while number % divisor == 0:
                number //= divisor
        divisor += 1
    if number > 1:
        factors.append(number)
    return factors


def is_testable(prime: int, steps: int, remaining_sum: int) -> bool:
    """Theorem R: `p` can divide every remaining entry iff `p|S` and `p*k <= S`."""
    return remaining_sum % prime == 0 and prime * steps <= remaining_sum


def testable_state(state: int, steps: int, remaining_sum: int) -> int:
    """`T(g,k,S)` -- the minimal sufficient replacement for the gcd coordinate."""
    if state == 0:
        return 0
    product_of = 1
    for prime in prime_factors(state):
        if is_testable(prime, steps, remaining_sum):
            product_of *= prime
    return product_of


def over_refines(state: int, steps: int, remaining_sum: int) -> bool:
    """Does the radical state distinguish more than the continuations can?"""
    return testable_state(state, steps, remaining_sum) < radical(state)


def continuations(steps: int, remaining_sum: int):
    """Every tuple of `steps` positive integers summing to `remaining_sum`."""
    if steps < 1 or remaining_sum < steps:
        return
    for tail in product(range(1, remaining_sum + 1), repeat=steps):
        if sum(tail) == remaining_sum:
            yield tail


def surviving_gcd(state: int, tail) -> int:
    return reduce(gcd, (state,) + tuple(tail))


def behaviourally_equal(left: int, right: int, steps: int,
                        remaining_sum: int) -> bool:
    """Do two gcd states accept exactly the same continuations?"""
    return all((surviving_gcd(left, tail) == 1) == (surviving_gcd(right, tail) == 1)
               for tail in continuations(steps, remaining_sum))


def main() -> None:
    print("Theorem R: p is testable iff p | S and p*k <= S\n")
    print("  S   k   testable primes among 2,3,5,7")
    for remaining_sum, steps in ((5, 1), (5, 2), (6, 2), (6, 3), (12, 2), (12, 5)):
        live = [p for p in (2, 3, 5, 7) if is_testable(p, steps, remaining_sum)]
        print(f"  {remaining_sum:2}  {steps:2}   {live}")

    print("\nThe radical state over-refines. Discriminating instance: S = 5.")
    for steps in (1, 2, 3, 4):
        if 5 < steps:
            continue
        same = behaviourally_equal(6, 1, steps, 5)
        print(f"  k={steps}: rad g = 6 and rad g = 1 behaviourally equal: {same}"
              f"   T(6,k,5) = {testable_state(6, steps, 5)}")

    print("\nThree strictly nested quotients, not two:")
    print("  exact gcd  >  radical  >  testable primes")
    total = over = 0
    for state in range(2, 60):
        for remaining_sum in range(2, 30):
            total += 1
            if gcd(radical(state), remaining_sum) < radical(state):
                over += 1
    print(f"  gcd(rad g, S) < rad g for {over} of {total} pairs"
          f" -- over-refinement is the norm")


if __name__ == "__main__":
    main()
