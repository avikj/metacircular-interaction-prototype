#!/usr/bin/env python3
"""Exact group-ring falsifier for the rational pair-phase identities."""

from __future__ import annotations

from math import gcd


def require(condition: bool, message: object) -> None:
    if not condition:
        raise RuntimeError(message)


def weights(limit: int) -> list[int]:
    """A signed, zero-containing sequence; primality is irrelevant here."""
    return [0] + [((n * n + 3 * n + 1) % 13) - 6 for n in range(1, limit + 1)]


def goldbach_phase_rows(u: list[int], q: int, a: int, N: int) -> dict[int, int]:
    rows: dict[int, int] = {}
    for m in range(1, N):
        n = N - m
        if n >= len(u):
            continue
        residue = (a * m + a * n) % q
        rows[residue] = rows.get(residue, 0) + u[m] * u[n]
    return {residue: value for residue, value in rows.items() if value}


def gap_phase_rows(u: list[int], q: int, a: int, h: int) -> dict[tuple[int, int], int]:
    """Keys are (radial exponent m+n, phase residue m-n)."""
    rows: dict[tuple[int, int], int] = {}
    for n in range(1, len(u) - h):
        m = n + h
        key = (m + n, (a * m - a * n) % q)
        rows[key] = rows.get(key, 0) + u[m] * u[n]
    return {key: value for key, value in rows.items() if value}


def main() -> None:
    if not __debug__:
        raise RuntimeError("do not run exact checks under python -O")
    u = weights(48)
    goldbach_checks = 0
    gap_checks = 0
    for q in range(2, 18):
        for a in range(1, q):
            if gcd(a, q) != 1:
                continue
            for N in range(2, len(u)):
                actual = goldbach_phase_rows(u, q, a, N)
                coefficient = sum(u[m] * u[N - m] for m in range(1, N))
                expected = {} if coefficient == 0 else {(a * N) % q: coefficient}
                require(actual == expected, ("Goldbach", q, a, N, actual, expected))
                goldbach_checks += 1
            for h in range(0, 13):
                actual = gap_phase_rows(u, q, a, h)
                expected = {
                    (2 * n + h, (a * h) % q): u[n + h] * u[n]
                    for n in range(1, len(u) - h)
                    if u[n + h] * u[n]
                }
                require(actual == expected, ("gap", q, a, h, actual, expected))
                gap_checks += 1
    print(f"Goldbach group-ring checks: {goldbach_checks}")
    print(f"gap group-ring checks: {gap_checks}")
    print("PASS")


if __name__ == "__main__":
    main()
