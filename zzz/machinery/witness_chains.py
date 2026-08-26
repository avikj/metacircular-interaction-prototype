"""What a critical witness costs the organism to build, by arithmetic form.

Companion to `notes/WITNESS_CHAIN_COST.md`.

Answers the hostile question closing
`collab/messages/0164-codex-ananta-witness-construction-result.md`:

    can multiplication or repeated squaring shorten the construction for the
    special valuation witness p^(E+1) while retaining a fair typed cost
    comparison with the general residue representative?

Yes, dramatically -- and the fair comparison is the point.  Two cost models for
building an integer from 1:

    A-chain    every step is c_j + c_k                 (codex-ananta, msg 0164)
    AM-chain   every step is c_j + c_k or c_j * c_k    (multiplication earned)

For the special witness `p^(E+1)` the AM cost collapses to roughly
`log_2 E + l(p)`, near the absolute floor `log_2 log_2 r`.  For a *generic*
witness of the same size no such saving exists: a counting argument forces
`log r / log log r` for all but a vanishing fraction.  So the saving is a
property of the witness's arithmetic FORM, not of the operation set.

Exhaustive shortest-chain search is exact for the small cases it covers, and is
therefore proof for those, not a measurement.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Sequence


# --------------------------------------------------- addition-only chains

def binary_addition_chain(r: int) -> list[int]:
    """The doubling construction of msg 0164: double, and add 1 per set bit."""
    if r < 1:
        raise ValueError("r must be positive")
    chain = [1]
    current = 1
    for bit in bin(r)[3:]:          # skip the leading 1
        current *= 2
        chain.append(current)
        if bit == "1":
            current += 1
            chain.append(current)
    return chain


def binary_addition_length(r: int) -> int:
    """floor(log2 r) + popcount(r) - 1, the length of the above."""
    if r < 1:
        raise ValueError("r must be positive")
    return (r.bit_length() - 1) + bin(r).count("1") - 1


# ------------------------------------------- addition + multiplication

def power_chain(p: int, e: int) -> list[int]:
    """An AM-chain for p^e: build p by doubling, then square-and-multiply.

    The exponent recursion is the one Pingala's prosodic rule is read as
    describing: halve the exponent and square, or drop one and multiply.
    See the note for the attribution boundary -- the recursion is used here
    as mathematics, not as a historical claim.
    """
    if p < 2 or e < 1:
        raise ValueError("require p >= 2 and e >= 1")
    chain = binary_addition_chain(p)
    powers = {1: p}
    current, acc = p, None
    exponent_bits = bin(e)[2:]
    # left-to-right square-and-multiply on the exponent
    acc = p
    for bit in exponent_bits[1:]:
        acc = acc * acc
        chain.append(acc)
        if bit == "1":
            acc = acc * p
            chain.append(acc)
    if acc != p ** e:
        raise AssertionError(f"power chain built {acc}, expected {p**e}")
    return chain


def power_chain_length(p: int, e: int) -> int:
    """l(p) + floor(log2 e) + popcount(e) - 1."""
    return (binary_addition_length(p)
            + (e.bit_length() - 1) + bin(e).count("1") - 1)


def is_valid_chain(chain: Sequence[int], allow_multiplication: bool) -> bool:
    """Every entry after the first is a sum (or product) of two earlier ones."""
    if not chain or chain[0] != 1:
        return False
    for i, value in enumerate(chain[1:], start=1):
        seen = chain[:i]
        ok = any(a + b == value for a in seen for b in seen)
        if allow_multiplication:
            ok = ok or any(a * b == value for a in seen for b in seen)
        if not ok:
            return False
    return True


def max_reachable(current_max: int, steps: int) -> int:
    """Largest value reachable in `steps` further AM-steps.

    Each step is at most a doubling or a squaring of the running maximum.
    """
    for _ in range(steps):
        current_max = max(current_max + current_max, current_max * current_max)
    return current_max


def am_lower_bound(r: int) -> int:
    """l_{+x}(r) >= ceil(log2 log2 r) + 1: each step at most squares the max."""
    if r < 2:
        return 0
    return math.ceil(math.log2(math.log2(r))) + 1 if r > 2 else 1


def shortest_am_chain(r: int, cap: int = 10) -> tuple[int | None, list[int] | None]:
    """Exact shortest AM-chain by iterative deepening.

    Exhaustive within `cap`, so the returned length is proved minimal, not
    estimated.  Returns (None, None) if no chain of length <= cap exists.
    """
    if r < 1:
        raise ValueError("r must be positive")
    if r == 1:
        return 0, [1]
    for depth in range(1, cap + 1):
        found = _search([1], r, depth)
        if found:
            return depth, found
    return None, None


def _search(chain: list[int], target: int, left: int) -> list[int] | None:
    if chain[-1] == target:
        return chain
    if left == 0 or max_reachable(max(chain), left) < target:
        return None
    top = max(chain)
    candidates = set()
    for i, a in enumerate(chain):
        for b in chain[i:]:
            for value in (a + b, a * b):
                if top < value <= target:
                    candidates.add(value)
    for value in sorted(candidates, reverse=True):
        found = _search(chain + [value], target, left - 1)
        if found:
            return found
    return None


# ---------------------------------------------------- the counting bound

def reachable_in_steps(steps: int, ceiling: int) -> set[int]:
    """Every integer <= ceiling reachable by an AM-chain of length <= steps.

    Exhaustive over chains, so this is an exact set, not a sample.
    """
    reached = {1}
    frontier = {(1,)}
    for _ in range(steps):
        nxt = set()
        for chain in frontier:
            top = max(chain)
            for i, a in enumerate(chain):
                for b in chain[i:]:
                    for value in (a + b, a * b):
                        if top < value <= ceiling:
                            reached.add(value)
                            nxt.add(chain + (value,))
        frontier = nxt
    return reached


def chain_count_bound(steps: int) -> int:
    """At most prod_{i=1..n} i(i+1) AM-chains of length n, hence that many
    reachable integers: i elements give i(i+1)/2 unordered pairs, times 2 ops.
    """
    total = 1
    for i in range(1, steps + 1):
        total *= i * (i + 1)
    return total


def generic_lower_bound(ceiling: int) -> float:
    """The counting bound: all but o(N) of r < N need this many AM-steps."""
    if ceiling < 4:
        return 0.0
    return math.log2(ceiling) / (2 * math.log2(math.log2(ceiling)))


@dataclass(frozen=True)
class CostComparison:
    """Typed cost of one witness, in both models."""

    witness: int
    addition_only: int
    multiplicative: int
    absolute_floor: int
    saving: int
    form: str


def compare(p: int, e: int) -> CostComparison:
    """The special witness p^e, priced in both models."""
    r = p ** e
    add = binary_addition_length(r)
    mul = power_chain_length(p, e)
    return CostComparison(
        witness=r, addition_only=add, multiplicative=mul,
        absolute_floor=am_lower_bound(r), saving=add - mul,
        form=f"{p}^{e}",
    )


if __name__ == "__main__":
    print("the special witness p^(E+1): addition-only against square-and-multiply")
    print(f"  {'r':>14} {'form':>8} {'A-chain':>9} {'AM-chain':>9} "
          f"{'floor':>6} {'saving':>7}")
    for p, e in ((3, 4), (3, 8), (5, 8), (2, 16), (3, 32), (7, 64), (3, 128)):
        c = compare(p, e)
        print(f"  {c.witness:>14} {c.form:>8} {c.addition_only:>9} "
              f"{c.multiplicative:>9} {c.absolute_floor:>6} {c.saving:>7}")

    print()
    print("but a generic witness of the same size gets no such discount:")
    for r in (81, 97, 101, 243, 251):
        n, chain = shortest_am_chain(r, cap=8)
        print(f"  r={r:>4}  shortest AM = {n}  {chain}")

    print()
    print("exact reachable counts against the counting bound:")
    for n in range(1, 6):
        exact = len(reachable_in_steps(n, 10**6))
        print(f"  steps={n}  reachable(<=10^6) = {exact:>6}   "
              f"bound = {chain_count_bound(n)}")
