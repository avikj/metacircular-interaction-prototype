#!/usr/bin/env python3
"""Exact accounting for a positional constructor grammar.

The artifact deliberately does not assign machine-dependent bit lengths to a
rule schema.  It counts declared constructors, executed constructor calls,
syntactic nodes, arithmetic values, and observer states separately.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import ceil, log2


@dataclass(frozen=True)
class CostProfile:
    base: int
    depth: int
    schema_constructors: int
    one_address_digits: int
    one_execution_calls: int
    syntax_nodes: int
    materialization_calls: int
    depth_k_objects: int
    arithmetic_values: int
    quotient_collisions: int
    worst_case_binary_name_bits: int


def geometric_sum(base: int, depth: int) -> int:
    return (base ** (depth + 1) - 1) // (base - 1)


def profile(base: int, depth: int) -> CostProfile:
    """Closed-form costs for all digit strings of lengths zero through depth."""
    if base < 2 or depth < 0:
        raise ValueError("need base >= 2 and depth >= 0")
    nodes = geometric_sum(base, depth)
    values = base**depth
    return CostProfile(
        base=base,
        depth=depth,
        schema_constructors=base + 1,  # one seed and b append schemas
        one_address_digits=depth,
        one_execution_calls=depth,
        syntax_nodes=nodes,
        materialization_calls=nodes - 1,
        depth_k_objects=values,
        arithmetic_values=values,
        quotient_collisions=nodes - values,
        worst_case_binary_name_bits=ceil(log2(values)) if values > 1 else 0,
    )


def value(word: tuple[int, ...], base: int) -> int:
    n = 0
    for digit in word:
        if not 0 <= digit < base:
            raise ValueError("digit outside the base")
        n = base * n + digit
    return n


def generate(base: int, depth: int) -> tuple[tuple[int, ...], ...]:
    """Materialize the prefix tree; used only to replay the declared formulas."""
    if base < 2 or depth < 0:
        raise ValueError("need base >= 2 and depth >= 0")
    layer: tuple[tuple[int, ...], ...] = ((),)
    all_words = [()]
    for _ in range(depth):
        layer = tuple(word + (digit,) for word in layer for digit in range(base))
        all_words.extend(layer)
    return tuple(all_words)


def representation_fiber(n: int, base: int, depth: int) -> tuple[tuple[int, ...], ...]:
    """All words of length <= depth denoting n, including leading-zero forms."""
    return tuple(word for word in generate(base, depth) if value(word, base) == n)


def observed_states(base: int, depth: int, modulus: int) -> int:
    """Number of residue states exposed among generated arithmetic values."""
    if modulus < 1:
        raise ValueError("modulus must be positive")
    return min(modulus, base**depth)


def main() -> None:
    p = profile(2, 3)
    print("binary constructors through depth 3")
    print(f"  schema constructors: {p.schema_constructors}")
    print(f"  calls to construct one depth-3 object: {p.one_execution_calls}")
    print(f"  calls to materialize the prefix tree: {p.materialization_calls}")
    print(f"  syntax nodes / arithmetic values: {p.syntax_nodes} / {p.arithmetic_values}")
    print(f"  syntax identifications under value: {p.quotient_collisions}")
    print(f"  worst-case bits to select one value: {p.worst_case_binary_name_bits}")
    print(f"  residue states retained by mod 3: {observed_states(2, 3, 3)}")


if __name__ == "__main__":
    main()
