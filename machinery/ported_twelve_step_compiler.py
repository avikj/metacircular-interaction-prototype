#!/usr/bin/env python3
"""Recursive reach with a live environmental choice at every level."""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class PortedStep:
    level: int
    weight: int
    choices_before: int
    choices_after: int


class PortedCompiler:
    def __init__(self, radix: int = 3) -> None:
        if radix < 2:
            raise ValueError("radix must be at least two")
        self.radix = radix
        self.weights: list[int] = []
        self.steps: list[PortedStep] = []

    def learn_once(self) -> PortedStep:
        weight = self.radix ** len(self.weights)
        before = 1 << len(self.weights)
        self.weights.append(weight)
        step = PortedStep(len(self.weights), weight, before, before * 2)
        self.steps.append(step)
        return step

    def run(self, count: int = 12) -> tuple[PortedStep, ...]:
        return tuple(self.learn_once() for _ in range(count))

    def respond(self, ports: tuple[int, ...]) -> int:
        if len(ports) != len(self.weights) or any(bit not in (0, 1) for bit in ports):
            raise ValueError("one binary choice is required for every formed level")
        return sum(bit * weight for bit, weight in zip(ports, self.weights))

    def decode(self, endpoint: int) -> tuple[int, ...]:
        if endpoint < 0:
            raise ValueError("endpoint must be nonnegative")
        digits = []
        value = endpoint
        for _ in self.weights:
            digit = value % self.radix
            if digit not in (0, 1):
                raise ValueError("endpoint is outside the realized response family")
            digits.append(digit)
            value //= self.radix
        if value:
            raise ValueError("endpoint exceeds the formed levels")
        return tuple(digits)

    @property
    def response_count(self) -> int:
        return 1 << len(self.weights)

    @property
    def maximum_span(self) -> int:
        return sum(self.weights)


def erased_port_control(levels: int, radix: int = 3) -> tuple[int, int]:
    """Always choosing one retains maximum endpoint but only one response."""
    return (sum(radix**k for k in range(levels)), 1)


def main() -> None:
    compiler = PortedCompiler()
    compiler.run(12)
    print("formed weights:", tuple(compiler.weights))
    print("live response functions:", compiler.response_count)
    print("maximum primitive span:", compiler.maximum_span)
    print("hours in twelve Julian years:", 12 * 365.25 * 24)
    print("erased-port control:", erased_port_control(12))


if __name__ == "__main__":
    main()
