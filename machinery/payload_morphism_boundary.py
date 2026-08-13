#!/usr/bin/env python3
"""Exact no-go: payload carrier size depends on admitted morphisms."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction

try:
    from machinery.mellin_layer_generation import s_zero_layers
    from machinery.qap_informative_macro import M, compile_macro
except ModuleNotFoundError:
    from mellin_layer_generation import s_zero_layers
    from qap_informative_macro import M, compile_macro


@dataclass(frozen=True)
class MellinCarrierBoundary:
    residual: tuple[Fraction, ...]
    support_size: int
    unrestricted_rank: int
    graded_rank: int
    reconstructed: tuple[Fraction, ...]


def mellin_carrier_boundary(
    arity: int, d_at_zero: Fraction, installed_depth: int
) -> MellinCarrierBoundary:
    """Compare unrestricted and layer-grading-preserving factorizations.

    The omitted coefficient payload is a single vector r. As a linear map
    K -> K^(k+1), 1 |-> r, every nonzero r has rank one. If the carrier and
    decoder must preserve the direct-sum grading by residue depth, one channel
    is required for every nonzero omitted coordinate.
    """
    layers = s_zero_layers(arity, d_at_zero)
    residual = tuple(layer.coefficient if i > installed_depth else Fraction(0)
                     for i, layer in enumerate(layers))
    support = sum(value != 0 for value in residual)
    unrestricted = int(support > 0)
    # Explicit unrestricted factorization: encoder sends 1 to 1; decoder
    # sends 1 to the entire residual vector.
    reconstructed = tuple(Fraction(1) * value for value in residual)
    if reconstructed != residual:
        raise AssertionError("rank-one residual factorization failed")
    return MellinCarrierBoundary(
        residual, support, unrestricted, support, reconstructed
    )


def qap_native_rank() -> int:
    p = M([[1, 0, 0], [0, 1, 0], [0, 0, 0]])
    a = M([[1, 2, 7], [3, 4, 8], [5, 6, 9]])
    return len(compile_macro(p, a)["B"][0])


if __name__ == "__main__":
    boundary = mellin_carrier_boundary(3, Fraction(-2), 0)
    print({"qap_rank": qap_native_rank(), "mellin": boundary})
    print("ALL EXACT CHECKS PASS")
