#!/usr/bin/env python3
"""Finite ternary port tower: endpoint speed versus developmental capacity.

The construction is deliberately elementary.  Every open level is a family
of translations indexed by the intervention trits accumulated so far.  The
nominal all-zero member is exactly the translation installed by the ternary
compiler.  Contracting the family to that member preserves the nominal
endpoint and erases the response family.
"""

from __future__ import annotations

from dataclasses import dataclass
from itertools import product
from typing import Iterable, Sequence


TRITS = (0, 1, 2)


def ternary_value(ports: Sequence[int]) -> int:
    """Little-endian ternary value used by the recursive extension law."""
    value = 0
    for digit in ports:
        if digit not in TRITS:
            raise ValueError("ports must be ternary digits")
        value = 3 * value + digit
    return value


@dataclass(frozen=True)
class PortTower:
    """A finite chart large enough that all declared responses stay distinct."""

    horizon: int

    def __post_init__(self) -> None:
        if self.horizon < 0:
            raise ValueError("horizon must be nonnegative")

    @property
    def modulus(self) -> int:
        # At depth H, displacement lies in [3^H, 2*3^H-1].
        return 2 * 3**self.horizon + 1

    def response(self, depth: int, x: int, ports: Sequence[int]) -> int:
        """P_k(x;a)=x+3^k+[a]_3 in the finite cyclic chart."""
        self._check_depth(depth)
        if len(ports) != depth:
            raise ValueError("one port is required for every extension")
        return (x + 3**depth + ternary_value(ports)) % self.modulus

    def nominal(self, depth: int, x: int) -> int:
        """Port contraction: evaluate the open process at the zero history."""
        self._check_depth(depth)
        return self.response(depth, x, (0,) * depth)

    def extend_response(
        self, depth: int, x: int, ports: Sequence[int], new_port: int
    ) -> int:
        """E(P)(x,a,d)=x+3(P(x,a)-x)+d, modulo the finite chart."""
        self._check_depth(depth + 1)
        if len(ports) != depth:
            raise ValueError("old history has the wrong depth")
        previous = self.response(depth, x, ports)
        return (x + 3 * ((previous - x) % self.modulus) + new_port) % self.modulus

    def responses(self, depth: int, x: int = 0) -> frozenset[int]:
        self._check_depth(depth)
        return frozenset(
            self.response(depth, x, ports)
            for ports in product(TRITS, repeat=depth)
        )

    def retained_responses(
        self, depth: int, retained: Iterable[int], x: int = 0
    ) -> frozenset[int]:
        """Missing ports are contracted to zero; retained ports remain live."""
        self._check_depth(depth)
        kept = frozenset(retained)
        if any(i < 0 or i >= depth for i in kept):
            raise ValueError("retained port outside the process")
        live = sorted(kept)
        outputs = set()
        for choices in product(TRITS, repeat=len(live)):
            ports = [0] * depth
            for i, digit in zip(live, choices):
                ports[i] = digit
            outputs.add(self.response(depth, x, ports))
        return frozenset(outputs)

    def _check_depth(self, depth: int) -> None:
        if depth < 0 or depth > self.horizon:
            raise ValueError("depth outside declared finite horizon")


def response_capacity(retained_port_count: int) -> int:
    """Exact number of distinguishable responses after partial contraction."""
    if retained_port_count < 0:
        raise ValueError("port count must be nonnegative")
    return 3**retained_port_count


def marginal_capacity(existing_ports: int) -> int:
    """Gain from retaining one more port: strictly increasing in context."""
    return response_capacity(existing_ports + 1) - response_capacity(existing_ports)


def full_process_replayable(depth: int, retained_rules: Iterable[int]) -> bool:
    """The recursive proof support is the conjunction {0,...,depth-1}."""
    if depth < 0:
        raise ValueError("depth must be nonnegative")
    return frozenset(range(depth)) <= frozenset(retained_rules)


def uninterrupted_capacity(initial_depth: int, later_extensions: int) -> int:
    return response_capacity(initial_depth + later_extensions)


def capacity_after_contraction(initial_depth: int, later_extensions: int) -> int:
    """Contract old ports once, then retain only ports introduced afterward."""
    if initial_depth < 0 or later_extensions < 0:
        raise ValueError("depths must be nonnegative")
    return response_capacity(later_extensions)


def eager_contraction_capacity(extensions: int) -> int:
    """Contract after every extension: nominal endpoints grow, ports do not."""
    if extensions < 0:
        raise ValueError("extensions must be nonnegative")
    return 1


if __name__ == "__main__":
    tower = PortTower(12)
    print("nominal displacement", 3**12)
    print("open response capacity", response_capacity(12))
    print("eager-contraction response capacity", eager_contraction_capacity(12))
    print("worst-case port reads: open 12, contracted 0")
