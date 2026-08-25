#!/usr/bin/env python3
"""Exact two-level macro for the oriented interval chain complex."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction

try:
    from machinery.qap_informative_macro import M, mul
except ModuleNotFoundError:
    from qap_informative_macro import M, mul

Matrix = list[list[Fraction]]


@dataclass(frozen=True)
class ChainMap:
    degree_one: Matrix
    degree_zero: Matrix


def is_chain_map(source_d: Matrix, target_d: Matrix, chain_map: ChainMap) -> bool:
    return mul(target_d, chain_map.degree_one) == mul(chain_map.degree_zero, source_d)


@dataclass(frozen=True)
class IntervalChainMacro:
    ambient_differential: Matrix
    carrier_differential: Matrix
    include: ChainMap
    coordinates: ChainMap
    target: ChainMap
    expansion: ChainMap
    base: ChainMap
    one_level_false_control: ChainMap
    carrier_total_dimension: int
    induced_h0_rank: int
    null_homotopy: Matrix


def compose(left: ChainMap, right: ChainMap) -> ChainMap:
    return ChainMap(mul(left.degree_one, right.degree_one),
                    mul(left.degree_zero, right.degree_zero))


def compile_interval_chain_macro() -> IntervalChainMacro:
    # C1=<e>, C0=<v0,v1>, d(e)=v1-v0.
    d = M([[-1], [1]])
    # K1=<u>, K0=<b>, dK(u)=b: the minimal generated carrier (U,dU).
    dk = M([[1]])
    include = ChainMap(M([[1]]), M([[-1], [1]]))
    coordinates = ChainMap(M([[1]]), M([[Fraction(-1, 2), Fraction(1, 2)]]))
    if not is_chain_map(dk, d, include):
        raise AssertionError("carrier inclusion is not a chain map")
    if not is_chain_map(d, dk, coordinates):
        raise AssertionError("carrier coordinate map is not a chain map")
    expansion = compose(include, coordinates)
    target = ChainMap(M([[1]]), M([
        [Fraction(1, 2), Fraction(-1, 2)],
        [Fraction(-1, 2), Fraction(1, 2)],
    ]))
    if expansion != target or not is_chain_map(d, d, target):
        raise AssertionError("two-level macro does not preserve denotation")
    base = ChainMap(M([[0]]), M([[0, 0], [0, 0]]))
    one_level = ChainMap(M([[1]]), base.degree_zero)
    if is_chain_map(d, d, one_level):
        raise AssertionError("one-level false control unexpectedly preserved d")
    # H0(C)=C0/im(d). Target degree-zero image lies inside im(d), so the
    # induced H0 map is zero, equal to the base map's induced H0 action.
    induced_h0_rank = 0
    homotopy = coordinates.degree_zero  # h:C0->C1
    if mul(homotopy, d) != target.degree_one or mul(d, homotopy) != target.degree_zero:
        raise AssertionError("target is not certified null-homotopic")
    return IntervalChainMacro(
        d, dk, include, coordinates, target, expansion, base, one_level, 2,
        induced_h0_rank, homotopy,
    )


if __name__ == "__main__":
    result = compile_interval_chain_macro()
    print(result)
    print("ALL EXACT CHECKS PASS")
