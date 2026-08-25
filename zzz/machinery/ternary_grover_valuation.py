#!/usr/bin/env python3
"""Exact one-query ternary-digit identification with a four-label phase oracle.

At a known prefix modulo `3^ell`, the valuation threshold for candidate digit
`d` is true exactly when `d` is the next digit. Add one dummy label that is
guaranteed false. The resulting oracle marks exactly one item in a four-item
search space, for which one ordinary Grover step is exact.

This module uses exact rational amplitudes. It declares a Boolean phase oracle;
it does not silently price compilation from a response-register valuation
oracle as free.
"""

from __future__ import annotations

from fractions import Fraction


Amplitude = Fraction
Vector = tuple[Amplitude, Amplitude, Amplitude, Amplitude]


UNIFORM: Vector = (Fraction(1, 2),) * 4


def phase_query(state: Vector, marked_digit: int) -> Vector:
    """Flip the phase of one digit in `{0,1,2}`; label 3 is the dummy."""
    if marked_digit not in (0, 1, 2):
        raise ValueError("a ternary digit must be 0, 1, or 2")
    return tuple(-amplitude if index == marked_digit else amplitude
                 for index, amplitude in enumerate(state))  # type: ignore[return-value]


def diffuse(state: Vector) -> Vector:
    """Four-point inversion about the mean."""
    mean = sum(state, Fraction(0)) / 4
    return tuple(2 * mean - amplitude for amplitude in state)  # type: ignore[return-value]


def identify_digit(marked_digit: int) -> tuple[int, Vector]:
    final = diffuse(phase_query(UNIFORM, marked_digit))
    support = [index for index, amplitude in enumerate(final) if amplitude]
    if support != [marked_digit] or final[marked_digit] != 1:
        raise AssertionError("the exact Grover step failed")
    return marked_digit, final


def valuation(number: int, prime: int, cap: int) -> int:
    if number % prime**cap == 0:
        return cap
    depth = 0
    while number % prime == 0:
        number //= prime
        depth += 1
    return depth


def threshold_mark(residue: int, prefix: int, level: int, digit: int, depth: int) -> bool:
    """The phase predicate implemented by a candidate valuation center."""
    if digit not in (0, 1, 2):
        return False  # the fourth program is a guaranteed-unmarked dummy
    modulus = 3**depth
    center = -(prefix + digit * 3**level) % modulus
    return valuation((residue + center) % modulus, 3, depth) >= level + 1


def reconstruct(residue: int, depth: int) -> tuple[int, int]:
    """Recover `residue mod 3^depth` with exactly `depth` phase queries."""
    if depth < 1:
        raise ValueError("depth must be positive")
    modulus = 3**depth
    residue %= modulus
    prefix = 0
    queries = 0
    for level in range(depth):
        marked = [digit for digit in range(4)
                  if threshold_mark(residue, prefix, level, digit, depth)]
        if len(marked) != 1:
            raise AssertionError("the threshold interface must mark one candidate")
        digit, _ = identify_digit(marked[0])
        prefix += digit * 3**level
        queries += 1
    return prefix, queries


def main() -> None:
    for depth in range(1, 5):
        modulus = 3**depth
        reconstructed, queries = reconstruct(modulus - 1, depth)
        print(
            f"depth={depth}: residue={modulus - 1}, reconstructed={reconstructed}, "
            f"quantum phase queries={queries}, classical minimax={2 * depth}"
        )


if __name__ == "__main__":
    main()

