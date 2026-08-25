#!/usr/bin/env python3
"""Precision growth reallocates reversible information; it does not erase it.

At the canonical valuation frontier just before `t = p^(L+1)`, the selected
chart is `mod p^L`: it has `p^L` visible values and maximum fibre `p`.  At the
transition the selected chart becomes `mod p^(L+1)`: it has `p^(L+1)` visible
values and maximum fibre one.  The output dimension grows by exactly the factor
lost by the coherent-overwrite environment.

If the old output chart is held fixed, its environment dimension remains `p`.
Thus the apparent reset is a change of system/environment factorization, not an
environment-only operation or a thermodynamic erasure statement.
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class InterfaceProfile:
    world_size: int
    modulus: int
    image_size: int
    environment_dimension: int

    @property
    def rectangular_capacity(self) -> int:
        return self.image_size * self.environment_dimension

    @property
    def unused_cells(self) -> int:
        return self.rectangular_capacity - self.world_size


def _check(prime: int, level: int) -> None:
    if prime < 2:
        raise ValueError("prime must be at least two")
    if level < 0:
        raise ValueError("level must be nonnegative")


def profile(world_size: int, modulus: int) -> InterfaceProfile:
    """Exact basis-interface profile on `S={1,...,world_size}`.

    The coherent overwrite dimension is the maximum residue-fibre size.
    """
    if world_size < 1 or modulus < 1:
        raise ValueError("world size and modulus must be positive")
    fibres: dict[int, int] = {}
    for value in range(1, world_size + 1):
        residue = value % modulus
        fibres[residue] = fibres.get(residue, 0) + 1
    return InterfaceProfile(
        world_size=world_size,
        modulus=modulus,
        image_size=len(fibres),
        environment_dimension=max(fibres.values()),
    )


def transition_profiles(prime: int, level: int) -> tuple[InterfaceProfile, InterfaceProfile]:
    """Selected interfaces immediately before and at `p^(level+1)`."""
    _check(prime, level)
    frontier = prime ** (level + 1)
    before = profile(frontier - 1, prime**level)
    after = profile(frontier, frontier)
    return before, after


def fixed_old_chart_after_transition(prime: int, level: int) -> InterfaceProfile:
    """The hostile control: encounter the frontier but retain `mod p^level`."""
    _check(prime, level)
    frontier = prime ** (level + 1)
    return profile(frontier, prime**level)


def main() -> None:
    print("p  L  before (output,env,capacity,slack)  after  fixed-old-env")
    for prime in (2, 3, 5):
        for level in (1, 2, 3):
            before, after = transition_profiles(prime, level)
            fixed = fixed_old_chart_after_transition(prime, level)
            print(
                f"{prime}  {level}  "
                f"({before.image_size},{before.environment_dimension},"
                f"{before.rectangular_capacity},{before.unused_cells})  "
                f"({after.image_size},{after.environment_dimension},"
                f"{after.rectangular_capacity},{after.unused_cells})  "
                f"{fixed.environment_dimension}"
            )


if __name__ == "__main__":
    main()

