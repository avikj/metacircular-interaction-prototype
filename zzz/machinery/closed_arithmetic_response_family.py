#!/usr/bin/env python3
"""Exact response laws for scalar multiplication modulo a prime.

Finite tables are regression witnesses only.  The proofs used by the note are
the multiplicative-order law for autonomous reuse and regularity of the unit
action for arbitrary continuations.
"""

from __future__ import annotations

from dataclasses import dataclass, field


def observe(x: int, prime: int) -> str:
    residue = x % prime
    if residue == 0:
        return "zero"
    if residue == 1:
        return "one"
    return "other"


def compose_scalars(left: int, right: int, prime: int) -> int:
    """mu_left after mu_right is mu_(left*right)."""
    return (left * right) % prime


def autonomous_signature(a: int, prime: int, horizon: int) -> tuple[str, ...]:
    """Fixed schedule epsilon, mu_a, ..., mu_a^horizon from seed one."""
    value = 1
    out = []
    for _ in range(horizon + 1):
        out.append(observe(value, prime))
        value = value * a % prime
    return tuple(out)


def full_continuation_signature(a: int, prime: int) -> tuple[str, ...]:
    """Responses after every admitted left scalar continuation, in label order."""
    return tuple(observe(b * a, prime) for b in range(prime))


def fibers(signatures: dict[int, tuple[str, ...]]) -> tuple[tuple[int, ...], ...]:
    grouped: dict[tuple[str, ...], list[int]] = {}
    for state, signature in signatures.items():
        grouped.setdefault(signature, []).append(state)
    return tuple(sorted(tuple(group) for group in grouped.values()))


def one_use_fibers(prime: int) -> tuple[tuple[int, ...], ...]:
    return fibers({a: (observe(a, prime),) for a in range(prime)})


def autonomous_fibers(prime: int, horizon: int) -> tuple[tuple[int, ...], ...]:
    return fibers(
        {a: autonomous_signature(a, prime, horizon) for a in range(prime)}
    )


def full_fibers(prime: int) -> tuple[tuple[int, ...], ...]:
    return fibers({a: full_continuation_signature(a, prime) for a in range(prime)})


@dataclass
class InstallationLedger:
    """Predictions have no installation authority; ports do."""

    prime: int
    predictions: list[int] = field(default_factory=list)
    installed: int | None = None
    provenance: str | None = None

    def predict(self, scalar: int) -> tuple[str, ...]:
        scalar %= self.prime
        self.predictions.append(scalar)
        return autonomous_signature(scalar, self.prime, self.prime - 1)

    def authorize(self, scalar: int, provenance: str) -> None:
        if not provenance:
            raise ValueError("installation requires causal provenance")
        self.installed = scalar % self.prime
        self.provenance = provenance


if __name__ == "__main__":
    print("one use:", one_use_fibers(5))
    print("autonomous powers:", autonomous_fibers(5, 4))
    print("all scalar continuations:", full_fibers(5))
