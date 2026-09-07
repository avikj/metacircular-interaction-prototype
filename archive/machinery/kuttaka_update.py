#!/usr/bin/env python3
"""Incrementally compose congruence sensors by one Euclidean state update."""
from __future__ import annotations

from dataclasses import dataclass
from math import gcd, lcm


@dataclass(frozen=True)
class CongruenceState:
    residue: int
    modulus: int

    def __post_init__(self) -> None:
        if self.modulus <= 0:
            raise ValueError("modulus must be positive")
        object.__setattr__(self, "residue", self.residue % self.modulus)


@dataclass(frozen=True)
class UpdateCertificate:
    before: CongruenceState
    added: CongruenceState
    gcd: int
    difference: int
    multiplier: int
    after: CongruenceState


@dataclass(frozen=True)
class Incompatibility:
    before: CongruenceState
    added: CongruenceState
    gcd: int
    difference: int


def extended_gcd(a: int, b: int) -> tuple[int, int, int]:
    """Return g,u,v with au+bv=g=gcd(a,b), via Euclidean quotients."""
    old_r, r, old_u, u, old_v, v = a, b, 1, 0, 0, 1
    while r:
        quotient = old_r // r
        old_r, r = r, old_r - quotient * r
        old_u, u = u, old_u - quotient * u
        old_v, v = v, old_v - quotient * v
    if old_r < 0:
        return -old_r, -old_u, -old_v
    return old_r, old_u, old_v


def add_constraint(
    state: CongruenceState, residue: int, modulus: int
) -> UpdateCertificate | Incompatibility:
    """Compose x=r mod M with x=a mod m, or emit the gcd obstruction."""
    added = CongruenceState(residue, modulus)
    difference = added.residue - state.residue
    g, inverse_coefficient, _ = extended_gcd(state.modulus, added.modulus)
    if difference % g:
        return Incompatibility(state, added, g, difference)
    reduced_modulus = added.modulus // g
    multiplier = ((difference // g) * inverse_coefficient) % reduced_modulus
    combined_modulus = lcm(state.modulus, added.modulus)
    after = CongruenceState(state.residue + state.modulus * multiplier,
                            combined_modulus)
    return UpdateCertificate(state, added, g, difference, multiplier, after)


def verify(result: UpdateCertificate | Incompatibility) -> bool:
    """Check the certificate or obstruction without trusting the constructor."""
    if isinstance(result, Incompatibility):
        return (result.gcd == gcd(result.before.modulus, result.added.modulus)
                and result.difference % result.gcd != 0)
    return (
        result.gcd == gcd(result.before.modulus, result.added.modulus)
        and result.after.modulus == lcm(result.before.modulus, result.added.modulus)
        and result.after.residue % result.before.modulus == result.before.residue
        and result.after.residue % result.added.modulus == result.added.residue
    )


if __name__ == "__main__":
    state = CongruenceState(0, 1)
    for residue, modulus in ((2, 8), (5, 9), (4, 5)):
        result = add_constraint(state, residue, modulus)
        print(result)
        if isinstance(result, Incompatibility):
            break
        state = result.after
