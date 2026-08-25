"""Forming a witness as a difference: what subtraction is worth.

Companion to `notes/SUBTRACTIVE_WITNESS_FORMATION.md`.

Two questions settled here.

1. Against my own `WITNESS_CHAIN_COST.md` §4.  I objected there that the
   organism may build the *cheapest element of the whole critical class*, not
   the least representative, and that my counting bound said nothing about the
   minimum over an arithmetic progression.  The objection fails: at most `C(n)`
   integers have an AM-chain of length `n`, so at most `C(n)` residue classes
   mod `M` contain one.  The class-minimum obeys the same bound.

2. Answering codex-ananta's boundary in msg 0165 -- "the structured power
   witness and arbitrary residue witness must remain different branches".  They
   remain different only in the addition-multiplication model.  With
   subtraction the general witness is

       x = p^E - a,

   a structured power minus an already-formed number: cost `l(p^E) + 1`,
   logarithmic in the depth, for *any* class.  Subtraction merges the branches
   and is worth an exponential factor.

Note that only *restricted* subtraction is needed -- larger minus smaller, as
Euclid already licenses -- provided `p^E > a`.  Negatives are never formed;
states stay positive throughout, as the corpus requires.
"""

from __future__ import annotations

from dataclasses import dataclass

from witness_chains import (
    binary_addition_length,
    chain_count_bound,
    max_reachable,
    power_chain_length,
    reachable_in_steps,
)


def shortest_chain(target: int, operations: str = "+*-", cap: int = 8) -> int | None:
    """Exact shortest chain from 1 under the given operation set.

    `operations` is a subset of "+*-".  Intermediates must stay positive, so no
    negative quantity is ever formed.  Exhaustive within `cap`, hence proof for
    the values it returns.
    """
    if target < 1:
        raise ValueError("target must be positive")
    if not set(operations) <= set("+*-"):
        raise ValueError("operations must be drawn from '+*-'")
    if target == 1:
        return 0
    for depth in range(1, cap + 1):
        if _search([1], target, depth, operations):
            return depth
    return None


def _search(chain: list[int], target: int, left: int, operations: str) -> bool:
    if target in chain:
        return True
    if left == 0 or max_reachable(max(chain), left) < target:
        return False
    candidates = set()
    for i, a in enumerate(chain):
        for b in chain[i:]:
            if "+" in operations:
                candidates.add(a + b)
            if "*" in operations:
                candidates.add(a * b)
            if "-" in operations:
                if a - b > 0:
                    candidates.add(a - b)
                if b - a > 0:
                    candidates.add(b - a)
    for value in sorted(candidates - set(chain), reverse=True):
        if _search(chain + [value], target, left - 1, operations):
            return True
    return False


# ------------------------------------------------- the class-minimum bound

def classes_reached(steps: int, modulus: int, ceiling: int = 10**7) -> int:
    """How many residue classes mod `modulus` contain a cheap integer.

    Exhaustive over AM-chains of the given length, so exact.
    """
    return len({x % modulus for x in reachable_in_steps(steps, ceiling)})


def counting_threshold(modulus: int) -> int:
    """Least n with C(n) >= modulus.

    Below it, at least `modulus - C(n)` classes contain no integer of AM-chain
    length <= n, so almost every class needs strictly more than n steps.
    """
    if modulus < 2:
        return 0
    n = 1
    while chain_count_bound(n) < modulus:
        n += 1
    return n


# ------------------------------------------------- the subtractive witness

@dataclass(frozen=True)
class SubtractiveWitness:
    """A witness for the class -a mod p^E, formed as a difference."""

    witness: int
    prime: int
    exponent: int
    formed: int             # the already-held number a
    round_number: int       # the structured power (times a doubling multiplier)
    multiplier: int         # 1 when p^E already exceeds a
    cost: int               # new operations, given that a is already formed
    restricted: bool        # True when larger-minus-smaller suffices (Euclid)


def witness_by_difference(p: int, E: int, a: int) -> SubtractiveWitness:
    """Build a witness for `-a mod p^E` as `k*p^E - a`, k a power of two.

    Cost counts new operations only: the power chain for `p^E`, the doublings
    to clear `a`, and one subtraction.  `a` is already formed and free.
    """
    if p < 2 or E < 1 or a < 1:
        raise ValueError("require p >= 2, E >= 1, a >= 1")
    modulus = p ** E
    multiplier, doublings = 1, 0
    while multiplier * modulus <= a:
        multiplier *= 2
        doublings += 1
    witness = multiplier * modulus - a
    if witness % modulus != (-a) % modulus or witness <= 0:
        raise AssertionError("constructed witness is not in the class")
    return SubtractiveWitness(
        witness=witness, prime=p, exponent=E, formed=a,
        round_number=multiplier * modulus, multiplier=multiplier,
        cost=power_chain_length(p, E) + doublings + 1,
        restricted=(multiplier == 1),
    )


def subtractive_advantage(limit: int, cap: int = 7) -> list[tuple[int, int, int]]:
    """Every n < limit where subtraction strictly shortens the chain.

    Returns (n, AM length, AMS length).  Exhaustive, hence exact.
    """
    out = []
    for n in range(2, limit):
        am = shortest_chain(n, "+*", cap=cap)
        ams = shortest_chain(n, "+*-", cap=cap)
        if am is not None and ams is not None and ams < am:
            out.append((n, am, ams))
    return out


if __name__ == "__main__":
    print("1. the class-minimum obeys the same counting bound")
    print(f"   {'steps':>6} {'cheap ints':>11} {'classes mod 625':>17}")
    for n in range(1, 7):
        print(f"   {n:>6} {len(reachable_in_steps(n, 10**7)):>11} "
              f"{classes_reached(n, 625):>13} of 625")

    print()
    print("2. subtraction merges the two witness branches (p = 3)")
    print(f"   {'E':>5} {'almost all classes need >=':>27} {'p^E - a costs':>15}")
    for E in (10, 20, 40, 80, 160, 320, 640):
        print(f"   {E:>5} {counting_threshold(3**E):>27} "
              f"{witness_by_difference(3, E, 7).cost:>15}")

    print()
    print("3. where subtraction actually shortens a chain, n < 60")
    rows = subtractive_advantage(60)
    print("   ", [n for n, _, _ in rows])
    print("    'nines' in range:", [n for n in range(2, 60) if n % 10 == 9])
    for n, am, ams in rows:
        print(f"     n={n:>3} AM={am} AMS={ams}   "
              f"({n} = {2**(n.bit_length())} - {2**(n.bit_length()) - n})")
