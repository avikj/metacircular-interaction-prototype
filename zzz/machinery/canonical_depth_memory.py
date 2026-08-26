#!/usr/bin/env python3
"""Depth and reversible memory are locked along the canonical encounter order.

`notes/DEPTH_MEMORY_NONMONOTONICITY.md` proves two opposing monotonicities --
refining the chart shrinks fibres, enlarging the world grows them -- and
concludes that "no monotone law relates semantic depth to reversible memory
without additional fiber-balance hypotheses".  That is correct for arbitrary
hand-built worlds.

For the order an organism built from zero and successor actually meets,
`S_t = {1,...,t}`, the fibre balance is not a missing hypothesis: it is a
theorem.  With the valuation observable `v_p` and the p-adic chart chain,

    D(t) = floor(log_p t)                                    (Theorem D)
    M(t) = floor((t-1) / p^D(t)) + 1,     1 <= M(t) <= p     (Theorem M)

so semantic depth grows without bound while reversible overwrite memory is
permanently bounded by `p`, and `M` sawtooths: it climbs from 1 to p across
each interval `[p^L, p^(L+1))` and resets to 1 exactly at the depth increments.
"Depth rises while memory falls" is therefore not an occasional coincidence in
this order -- it happens at `t = p^(L+1)` and nowhere else.

All arithmetic is exact.  `global_depth` and `max_fibre` evaluate the target
note's definitions (1) and (2) literally, by enumeration.
"""

from __future__ import annotations


def valuation(number: int, prime: int) -> int:
    if number == 0:
        raise ValueError("the canonical world contains no zero")
    height = 0
    while number % prime == 0:
        number //= prime
        height += 1
    return height


def global_depth(world, prime: int, cap: int = 64) -> int:
    """`D_S` of DEPTH_MEMORY_NONMONOTONICITY (1): least chart constant on every fibre."""
    members = list(world)
    for depth in range(cap):
        modulus = prime ** depth
        seen: dict[int, set[int]] = {}
        for member in members:
            seen.setdefault(member % modulus, set()).add(valuation(member, prime))
        if all(len(values) == 1 for values in seen.values()):
            return depth
    raise ValueError("no chart in range is sufficient")


def max_fibre(world, prime: int, depth: int) -> int:
    """`M_S` of (2): the largest class the selected chart overwrites."""
    modulus = prime ** depth
    counts: dict[int, int] = {}
    for member in world:
        counts[member % modulus] = counts.get(member % modulus, 0) + 1
    return max(counts.values())


def canonical_depth(prime: int, time: int) -> int:
    """Theorem D.  `D({1,...,t}) = floor(log_p t)`.

    Proof.  A fibre of the mod-`p^k` chart is `{y <= t : y = r mod p^k}`.
    If `v_p(r) = j < k` then every member has `v_p = j`, so the fibre is
    constant.  The one remaining fibre is `r = 0`, namely
    `{m p^k : 1 <= m <= floor(t/p^k)}`, on which `v_p = k + v_p(m)`; this is
    constant exactly when no two admissible `m` differ in `v_p`, i.e. when
    `floor(t/p^k) <= p-1`, i.e. when `t < p^(k+1)`.  So depth `k` suffices iff
    `k >= floor(log_p t)`, and the least such `k` is `floor(log_p t)`.  []
    """
    if time < 1:
        raise ValueError("time starts at one")
    depth = 0
    while prime ** (depth + 1) <= time:
        depth += 1
    return depth


def canonical_memory(prime: int, time: int) -> int:
    """Theorem M.  `M({1,...,t}) = floor((t-1)/p^D) + 1`, and `1 <= M <= p`.

    Proof.  At depth `D` the class of `r` in `[1,t]` has
    `floor((t-r)/p^D) + 1` members, which is nonincreasing in `r`, so `r = 1`
    maximises.  Since `p^D <= t < p^(D+1)`, the quotient `(t-1)/p^D` lies in
    `[0, p)`, giving `1 <= M <= p`.  []

    Corollary (sawtooth).  `M` is nondecreasing on each `[p^L, p^(L+1))` and
    resets to 1 at `t = p^(L+1)`.  Its maximum on that tooth is
    `M(p^(L+1) - 1) = p` for `L >= 1`, and `p - 1` on the initial tooth
    `L = 0`, since there `p^L = 1` and the tooth is only `p-1` long.  Hence
    memory strictly decreases *only* at the instants when depth rises -- and at
    every such instant except the very first when `p = 2`, where the initial
    tooth has height `p - 1 = 1` and the reset is not strict.
    """
    depth = canonical_depth(prime, time)
    return (time - 1) // prime ** depth + 1


def canonical_profile(prime: int, time: int) -> tuple[int, int]:
    return canonical_depth(prime, time), canonical_memory(prime, time)


def hitting_time(prime: int, point: int) -> int:
    """`codex-ananta`'s `tau_p(x) = max(x, p^(v_p(x)+1))` -- their formula, not mine.

    Recorded here because my own `ENCOUNTER_ORDER_DEPTH` asserted no offset was
    needed, which is true only for `x = p^E`.  For `x = p^E u` with `u > p` the
    witness precedes the object and `tau = x`.
    """
    return max(point, prime ** (valuation(point, prime) + 1))


def main() -> None:
    for prime in (2, 3, 5):
        span = prime ** 3 + 2
        times = list(range(1, span))
        print(f"p = {prime}   canonical order S_t = {{1,...,t}}")
        print("  t :", " ".join(f"{t:2}" for t in times))
        print("  D :", " ".join(f"{canonical_depth(prime, t):2}" for t in times))
        print("  M :", " ".join(f"{canonical_memory(prime, t):2}" for t in times))
        drops = [t for t in times[1:]
                 if canonical_memory(prime, t) < canonical_memory(prime, t - 1)]
        powers = [prime ** j for j in range(1, 4) if prime ** j < span]
        print(f"  memory falls exactly at t = {drops}; powers of p = {powers}")
        print(f"  depth is unbounded, memory never exceeds p = {prime}\n")


if __name__ == "__main__":
    main()
