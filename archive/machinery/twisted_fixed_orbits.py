#!/usr/bin/env python3
"""Exact twisted fixed-point formula for an equivariant finite endomap."""

from __future__ import annotations

from dataclasses import dataclass
from math import gcd
from typing import Hashable, Mapping, Sequence

State = Hashable


@dataclass(frozen=True)
class TwistedFixedCertificate:
    orbit_count: int
    fixed_orbit_count: int
    ordinary_fixed_orbits: int
    twisted_counts: tuple[int, ...]


def compile_twisted_fixed_orbits(
    carrier: Sequence[State],
    actions: Sequence[Mapping[State, State]],
    endomap: Mapping[State, State],
) -> TwistedFixedCertificate:
    """Check a finite group action table and the twisted trace identity.

    `actions` lists every group element as a permutation, with identity first.
    Closure is checked extensionally; `endomap` must commute with every action.
    """
    states = tuple(carrier)
    state_set = set(states)
    if not states or len(state_set) != len(states):
        raise ValueError("carrier must be nonempty and duplicate-free")
    if not actions or set(endomap) != state_set or not set(endomap.values()) <= state_set:
        raise ValueError("action family and total endomap are required")
    encoded = []
    for action in actions:
        if set(action) != state_set or set(action.values()) != state_set:
            raise ValueError("every action must be a permutation")
        encoded.append(tuple(action[x] for x in states))
    if encoded[0] != states or len(set(encoded)) != len(encoded):
        raise ValueError("actions must list the identity first without duplicates")
    encoded_set = set(encoded)
    for left in actions:
        for right in actions:
            composite = tuple(left[right[x]] for x in states)
            if composite not in encoded_set:
                raise ValueError("actions are not closed under composition")
    for action in actions:
        if any(endomap[action[x]] != action[endomap[x]] for x in states):
            raise ValueError("endomap is not equivariant")

    unseen, orbit_index, orbit_count = set(states), {}, 0
    while unseen:
        seed = next(x for x in states if x in unseen)
        orbit = {action[seed] for action in actions}
        for x in orbit:
            orbit_index[x] = orbit_count
        unseen -= orbit
        orbit_count += 1

    fixed_orbits = sum(
        orbit_index[endomap[next(x for x in states if orbit_index[x] == i)]] == i
        for i in range(orbit_count)
    )
    raw_fixed = {x for x in states if endomap[x] == x}
    ordinary_fixed_orbits = len({orbit_index[x] for x in raw_fixed})
    twisted = tuple(sum(endomap[x] == action[x] for x in states)
                    for action in actions)
    if sum(twisted) != len(actions) * fixed_orbits:
        raise AssertionError("twisted fixed-point formula failed")
    return TwistedFixedCertificate(
        orbit_count, fixed_orbits, ordinary_fixed_orbits, twisted,
    )


def cyclic_multiplier_certificate(modulus: int, action_multiplier: int,
                                  order: int, endomorphism_multiplier: int):
    if modulus <= 0 or order <= 0:
        raise ValueError("modulus and order must be positive")
    a, b = action_multiplier % modulus, endomorphism_multiplier % modulus
    if gcd(a, modulus) != 1 or pow(a, order, modulus) != 1:
        raise ValueError("declared cyclic action is invalid")
    if any(pow(a, k, modulus) == 1 for k in range(1, order)):
        raise ValueError("declared order is not minimal")
    states = tuple(range(modulus))
    actions = tuple({x: pow(a, k, modulus) * x % modulus for x in states}
                    for k in range(order))
    endomap = {x: b * x % modulus for x in states}
    certificate = compile_twisted_fixed_orbits(states, actions, endomap)
    arithmetic = tuple(gcd(b - pow(a, k), modulus) for k in range(order))
    if certificate.twisted_counts != arithmetic:
        raise AssertionError("gcd and enumerated twisted sectors disagree")
    return certificate, arithmetic


def smallest_failure():
    states = (0, 1)
    identity = {0: 0, 1: 1}
    flip = {0: 1, 1: 0}
    result = compile_twisted_fixed_orbits(states, (identity, flip), flip)
    assert result.fixed_orbit_count == 1
    assert result.ordinary_fixed_orbits == 0
    assert result.twisted_counts == (0, 2)
    return result


def main():
    small = smallest_failure()
    arithmetic, gcd_counts = cyclic_multiplier_certificate(15, 2, 4, 4)
    assert arithmetic.orbit_count == arithmetic.fixed_orbit_count == 5
    assert arithmetic.ordinary_fixed_orbits == 2
    assert gcd_counts == (3, 1, 15, 1)
    print({"smallest": small, "mod15": arithmetic, "gcd": gcd_counts})
    print("ALL EXACT CHECKS PASS")


if __name__ == "__main__":
    main()
