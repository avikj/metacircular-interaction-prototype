#!/usr/bin/env python3
"""Exact center-program dimension for modular translation processors."""

from __future__ import annotations

from typing import Iterable


def translation_permutation(modulus: int, center: int) -> tuple[int, ...]:
    if modulus < 1:
        raise ValueError("modulus must be positive")
    return tuple((value + center) % modulus for value in range(modulus))


def translations_equal_up_to_phase(modulus: int, left: int, right: int) -> bool:
    """For permutation translations, proportionality is equality."""
    return translation_permutation(modulus, left) == translation_permutation(
        modulus, right
    )


def exact_program_dimension(modulus: int, centers: Iterable[int]) -> int:
    """Minimum exact deterministic program dimension for declared translations."""
    if modulus < 1:
        raise ValueError("modulus must be positive")
    distinct = {center % modulus for center in centers}
    if not distinct:
        raise ValueError("at least one center is required")
    return len(distinct)


def center_program_qubits(modulus: int, centers: Iterable[int]) -> int:
    dimension = exact_program_dimension(modulus, centers)
    return (dimension - 1).bit_length()


if __name__ == "__main__":
    modulus = 3**4
    centers = range(modulus)
    print({
        "modulus": modulus,
        "program_dimension": exact_program_dimension(modulus, centers),
        "program_qubits": center_program_qubits(modulus, centers),
    })
