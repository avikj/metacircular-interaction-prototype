#!/usr/bin/env python3
"""Clean compute-copy-uncompute schedule for adaptive valuation sensing."""

from __future__ import annotations

from dataclasses import dataclass

from adaptive_valuation_centers import truncated_valuation


@dataclass(frozen=True)
class CleanRun:
    residue: int
    oracle_invocations: int
    response_ancilla: int
    retained_digits: tuple[int, ...]


def clean_reconstruct(residue: int, prime: int, depth: int) -> CleanRun:
    """Use a reversible valuation oracle twice per candidate digit test."""
    if prime < 2 or depth < 1:
        raise ValueError("prime and depth must be valid")
    modulus = prime**depth
    hidden = residue % modulus
    prefix = 0
    digits = []
    response = 0
    calls = 0
    for level in range(depth):
        place = prime**level
        digit_register = prime - 1
        for candidate_digit in range(prime - 1):
            center = (-(prefix + candidate_digit * place)) % modulus
            oracle_value = truncated_valuation(hidden + center, prime, depth)
            response ^= oracle_value
            calls += 1
            hit = response >= level + 1
            if hit:
                digit_register ^= (prime - 1) ^ candidate_digit
            # Inverse oracle with the unchanged query input clears the response.
            response ^= oracle_value
            calls += 1
            if response:
                raise AssertionError("response ancilla did not uncompute")
        digits.append(digit_register)
        prefix += digit_register * place
    if prefix != hidden:
        raise AssertionError("clean reconstruction failed")
    return CleanRun(prefix, calls, response, tuple(digits))


def mutated_center_residual(residue: int, prime: int, depth: int, center: int) -> int:
    """Wrong-order control: changing center before unquery generally leaves garbage."""
    modulus = prime**depth
    first = truncated_valuation(residue + center, prime, depth)
    changed_center = (center - 1) % modulus
    second = truncated_valuation(residue + changed_center, prime, depth)
    return first ^ second


if __name__ == "__main__":
    run = clean_reconstruct(73, 3, 4)
    print(run)
