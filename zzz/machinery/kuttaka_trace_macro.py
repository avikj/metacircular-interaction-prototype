#!/usr/bin/env python3
"""Exact repeated-block macros for Euclidean quotient traces."""

from __future__ import annotations

from dataclasses import dataclass

Matrix = tuple[tuple[int, int], tuple[int, int]]


def multiply(a: Matrix, b: Matrix) -> Matrix:
    return (
        (a[0][0] * b[0][0] + a[0][1] * b[1][0],
         a[0][0] * b[0][1] + a[0][1] * b[1][1]),
        (a[1][0] * b[0][0] + a[1][1] * b[1][0],
         a[1][0] * b[0][1] + a[1][1] * b[1][1]),
    )


def replay(trace: tuple[int, ...]) -> Matrix:
    result: Matrix = ((1, 0), (0, 1))
    for quotient in trace:
        result = multiply(result, ((quotient, 1), (1, 0)))
    return result


@dataclass(frozen=True)
class TraceMacro:
    block: tuple[int, ...]
    repetitions: int
    expansion: tuple[int, ...]
    block_payload: Matrix
    direct_payload: Matrix
    macro_payload: Matrix
    quotient_cost: int
    installed_cost: int
    strict_gain: int
    source_pair: tuple[int, int]


def compile_repeated_block(block: tuple[int, ...], repetitions: int) -> TraceMacro:
    """Compile block^r, charging |block| once and r macro invocations."""
    if not block or any(q < 0 for q in block):
        raise ValueError("quotient block must be nonempty and nonnegative")
    if repetitions < 2:
        raise ValueError("macro needs at least two uses")
    expansion = block * repetitions
    block_payload = replay(block)
    macro_payload: Matrix = ((1, 0), (0, 1))
    for _ in range(repetitions):
        macro_payload = multiply(macro_payload, block_payload)
    direct = replay(expansion)
    if macro_payload != direct:
        raise AssertionError("macro replay changed the Euclidean payload")
    quotient_cost = len(expansion)
    installed_cost = len(block) + repetitions
    source_pair = (direct[0][0], direct[1][0])
    if euclidean_trace(*source_pair) != expansion:
        raise ValueError("block expansion is not the canonical trace of its source pair")
    return TraceMacro(
        block, repetitions, expansion, block_payload, direct, macro_payload,
        quotient_cost, installed_cost, quotient_cost - installed_cost, source_pair,
    )


def euclidean_trace(a: int, b: int) -> tuple[int, ...]:
    if a <= 0 or b <= 0:
        raise ValueError("source pair must be positive")
    result = []
    while b:
        q, r = divmod(a, b)
        result.append(q)
        a, b = b, r
    return tuple(result)


def best_prefix_period(trace: tuple[int, ...]) -> TraceMacro | None:
    """Best exact whole-trace block repetition under quotient-symbol cost."""
    candidates = []
    for size in range(1, len(trace)):
        if len(trace) % size:
            continue
        repeats = len(trace) // size
        block = trace[:size]
        if block * repeats == trace:
            candidates.append(compile_repeated_block(block, repeats))
    profitable = [candidate for candidate in candidates if candidate.strict_gain > 0]
    return max(profitable, key=lambda item: item.strict_gain, default=None)


if __name__ == "__main__":
    result = best_prefix_period((1, 2) * 4)
    print(result)
    print("ALL EXACT CHECKS PASS")
