#!/usr/bin/env python3
"""A refining organism keeps constant quantum memory; a fixed sensor does not.

`notes/ARITHMETIC_QUOTIENT_QUANTUM_DILATION.md` §5 concludes:

    For the unbounded natural-number domain, every residue fiber is infinite,
    so no finite-dimensional overwritten coherent dilation exists.  Finite
    arithmetic charts therefore do not converge to one fixed finite quantum
    memory.

The first sentence is right.  The *therefore* silently holds the chart fixed.
An organism that refines its chart as its world grows -- which is what the
depth line of this corpus actually describes -- has a coherent-overwrite
dilation of dimension at most `p`, uniformly and forever.

Theorem Q, proved in `notes/REFINING_DILATION.md`:

  1. For the valuation observable `v_p` on the canonical world
     `S_t = {1,...,t}`, the minimal sufficient chart is `mod p^D(t)` with
     `D(t) = floor(log_p t)`  (`CANONICAL_DEPTH_MEMORY` Theorem D).
  2. By their Theorem 2.1 its least environment dimension is
     `d_E(t) = ceil(t / p^D(t))`.
  3. `ceil(t/m) = floor((t-1)/m) + 1`, so `d_E` is *literally* the quantity
     `M(t)` of `CANONICAL_DEPTH_MEMORY` Theorem M.  Two workers named the same
     function twice.
  4. `p^D <= t < p^(D+1)` gives `1 <= d_E(t) <= p`, with `p` attained at
     `t = p^(L+1) - 1`.  So `ceil(log2 p)` qubits suffice at every frontier:
     one qubit at `p = 2`, two at `p = 3`, forever.

Their own §4 example, read both ways: the fixed residue sensor `q_7` on 91
integers needs 13 environment levels and 4 qubits; the organism's minimal
sufficient chart for `v_7` on the same integers is `mod 49` and needs 2 levels
and **1 qubit**.

Nothing here is measured; every dimension is a maximum fibre cardinality
computed by enumeration, and the closed forms are proved.
"""

from __future__ import annotations

from math import ceil, log2


def valuation(number: int, prime: int) -> int:
    height = 0
    while number % prime == 0:
        number //= prime
        height += 1
    return height


def environment_dimension(observable, world) -> int:
    """Their Theorem 2.1: the least environment dimension is the largest fibre.

    For an isometry `V|x> = |q(x)>|e_x>`, inner-product preservation forces the
    environment vectors within a fibre to be orthonormal, and labels may be
    reused across fibres because the output register already separates them.
    """
    fibres: dict[object, int] = {}
    for element in world:
        key = observable(element)
        fibres[key] = fibres.get(key, 0) + 1
    return max(fibres.values())


def qubits(dimension: int) -> int:
    return 0 if dimension <= 1 else ceil(log2(dimension))


def minimal_sufficient_depth(prime: int, time: int) -> int:
    """`D(t) = floor(log_p t)` -- CANONICAL_DEPTH_MEMORY Theorem D."""
    if time < 1:
        raise ValueError("the canonical world starts at one")
    depth = 0
    while prime ** (depth + 1) <= time:
        depth += 1
    return depth


def fixed_sensor_dimension(modulus: int, size: int) -> int:
    """Their (5): `d_E(q_m restricted to {0..N-1}) = ceil(N/m)`, which diverges."""
    return ceil(size / modulus)


def refining_dimension(prime: int, time: int) -> int:
    """Theorem Q: `d_E` at the organism's minimal sufficient chart, always <= p."""
    return ceil(time / prime ** minimal_sufficient_depth(prime, time))


def refining_qubits(prime: int) -> int:
    """The uniform bound: `ceil(log2 p)` qubits at every frontier, forever."""
    return qubits(prime)


def divisibility_predicate_dimension(modulus: int, size: int) -> int:
    """The coarser predicate `[m | n]` costs *more*, not less.

    Refining shrinks fibres (`DEPTH_MEMORY_NONMONOTONICITY` Prop 2.1), so the
    two-valued divisibility observable has a fibre of size about `N(1 - 1/m)`.
    The cheap memory belongs to the valuation observable, not to any coarsening
    of it -- which is why the bound above is a statement about *which* sensor
    the organism retains.
    """
    return environment_dimension(lambda n: n % modulus == 0, range(size))


def main() -> None:
    print("A fixed residue sensor: their (5), d_E = ceil(N/m), unbounded")
    for size in (91, 1_000, 100_000):
        dimension = fixed_sensor_dimension(7, size)
        print(f"  q_7 on {size:7} integers: d_E = {dimension:6}"
              f"   qubits {qubits(dimension)}")

    print("\nA refining organism: Theorem Q, d_E <= p forever")
    print("  p   t range                d_E range   qubits")
    for prime in (2, 3, 5, 7):
        widest = max(refining_dimension(prime, t) for t in range(1, 5000))
        print(f"  {prime}   1 .. 4999               1 .. {widest}"
              f"       {refining_qubits(prime)}")

    print("\nTheir own §4 example, both readings:")
    print(f"  fixed q_7 on 91 integers          "
          f"d_E = {fixed_sensor_dimension(7, 91):3}  "
          f"qubits {qubits(fixed_sensor_dimension(7, 91))}")
    depth = minimal_sufficient_depth(7, 91)
    dimension = refining_dimension(7, 91)
    print(f"  minimal chart for v_7 on {{1..91}}   "
          f"d_E = {dimension:3}  qubits {qubits(dimension)}"
          f"   (depth {depth}, modulus {7 ** depth})")


if __name__ == "__main__":
    main()
