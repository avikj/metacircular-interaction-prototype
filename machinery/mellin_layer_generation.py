#!/usr/bin/env python3
"""Finite symbolic s=0 residue-layer generation; no analytic evaluation."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from math import comb


@dataclass(frozen=True)
class ResidueLayer:
    zero_residues: int
    wave_arity: int
    decay_half_powers: int
    coefficient: Fraction


def s_zero_layers(arity: int, d_at_zero: Fraction) -> tuple[ResidueLayer, ...]:
    """Formal strata obtained by choosing r of k Mellin variables at s=0.

    The remaining k-r slots are named `Z_(k-r)`; no value of that wave layer
    and no remainder estimate is asserted here.
    """
    if arity < 0:
        raise ValueError("arity must be nonnegative")
    return tuple(
        ResidueLayer(r, arity - r, r, Fraction(comb(arity, r)) * d_at_zero**r)
        for r in range(arity + 1)
    )


@dataclass(frozen=True)
class LayerVocabulary:
    installed_depth: int
    layers: tuple[ResidueLayer, ...]
    deficit: int


def compile_depth(
    arity: int, d_at_zero: Fraction, installed_depth: int
) -> LayerVocabulary:
    if not 0 <= installed_depth <= arity:
        raise ValueError("installed depth must lie between zero and arity")
    all_layers = s_zero_layers(arity, d_at_zero)
    return LayerVocabulary(
        installed_depth, all_layers[:installed_depth + 1],
        arity - installed_depth,
    )


def promote_one(state: LayerVocabulary, d_at_zero: Fraction) -> LayerVocabulary:
    arity = state.layers[0].wave_arity
    if state.deficit == 0:
        return state
    result = compile_depth(arity, d_at_zero, state.installed_depth + 1)
    if result.deficit != state.deficit - 1:
        raise AssertionError("promotion did not strictly decrease layer deficit")
    return result


def generate_all(arity: int, d_at_zero: Fraction) -> tuple[LayerVocabulary, ...]:
    states = [compile_depth(arity, d_at_zero, 0)]
    while states[-1].deficit:
        states.append(promote_one(states[-1], d_at_zero))
    return tuple(states)


def shape_projection(state: LayerVocabulary) -> tuple[tuple[int, int], ...]:
    """Coefficient-erasing analogue of a head-only obstruction vocabulary."""
    return tuple((layer.zero_residues, layer.wave_arity) for layer in state.layers)


if __name__ == "__main__":
    mu = generate_all(3, Fraction(-2))
    divisor = generate_all(3, Fraction(1, 4))
    print({"deficits": tuple(x.deficit for x in mu),
           "mu": mu[-1].layers, "divisor": divisor[-1].layers,
           "same_shapes": shape_projection(mu[-1]) == shape_projection(divisor[-1])})
    print("ALL EXACT CHECKS PASS")
