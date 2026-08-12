#!/usr/bin/env python3
"""One-shot arithmetic growth: collisions form lawful residue sensors."""

from __future__ import annotations

from dataclasses import dataclass
from math import gcd, isqrt, prod
from typing import Iterable


@dataclass(frozen=True)
class Event:
    kind: str
    subject: tuple[int, ...]
    detail: str
    parents: tuple[int, ...]


class ArithmeticLife:
    """A tiny process whose installed observations change its next action."""

    def __init__(self) -> None:
        self.moduli: list[int] = []
        self.generated_through = 1
        self.batch_compiled = False
        self.events: list[Event] = [
            Event("construct", (0, 1), "zero and successor", ()),
        ]

    def profile(self, n: int) -> tuple[int, ...]:
        return tuple(n % modulus for modulus in self.moduli)

    def _record(self, kind: str, subject: tuple[int, ...], detail: str) -> int:
        parents = () if not self.events else (len(self.events) - 1,)
        self.events.append(Event(kind, subject, detail, parents))
        return len(self.events) - 1

    def form_sensor_for_collision(self, left: int, right: int) -> int:
        """Install the least additive-quotient sensor separating a collision."""
        if left < 0 or right < 0 or left == right:
            raise ValueError("collision needs distinct natural numbers")
        if self.profile(left) != self.profile(right):
            raise ValueError("the current observations already separate the pair")
        modulus = next(
            m for m in range(2, max(left, right) + 2)
            if m not in self.moduli and left % m != right % m
        )
        self.moduli.append(modulus)
        self._record(
            "form-sensor", (left, right, modulus),
            f"mod {modulus} separates the collision; "
            "(a+b)%m=((a%m)+(b%m))%m",
        )
        return modulus

    def install_residue_sensor(self, modulus: int, reason: tuple[int, ...]) -> None:
        """Form a requested additive quotient, once, with its transport law."""
        if modulus < 2:
            raise ValueError("a residue sensor needs modulus >= 2")
        if modulus in self.moduli:
            return
        self.moduli.append(modulus)
        self._record(
            "form-sensor", reason + (modulus,),
            f"install mod {modulus}; "
            "(a+b)%m=((a%m)+(b%m))%m",
        )

    def _extend_prime_sensors_through(self, bound: int, encounter: int) -> None:
        """Generate only irreducible grouping sensors needed up to ``bound``."""
        for candidate in range(self.generated_through + 1, bound + 1):
            if candidate in self.moduli:
                continue
            divisor = next(
                (p for p in self.moduli
                 if p <= isqrt(candidate) and candidate % p == 0),
                None,
            )
            if divisor is not None:
                self._record(
                    "skip-derived", (candidate, divisor),
                    f"mod-{candidate} adds no prime test: {divisor} divides it",
                )
                continue
            self.install_residue_sensor(candidate, (encounter, candidate))
            self._record(
                "certify-sensor", (candidate,),
                f"no earlier prime sensor through sqrt({candidate}); {candidate} is prime",
            )
        self.generated_through = max(self.generated_through, bound)

    def factor(self, n: int) -> tuple[int, int] | None:
        """Let the current sensor frontier grow until equal grouping resolves n."""
        if n < 2:
            raise ValueError("factor encounter needs n >= 2")
        self._extend_prime_sensors_through(isqrt(n), n)
        active = tuple(p for p in self.moduli if p <= isqrt(n))
        if len(active) >= 2:
            wheel = prod(active)
            if not self.batch_compiled:
                self._record(
                    "compile-action", active + (wheel,),
                    "gcd(n,product sensors)>1 iff an installed prime divides n",
                )
                self.batch_compiled = True
            common = gcd(n, wheel)
            self._record(
                "act-batch", (n, wheel, common),
                "Euclidean descent interrogates all installed prime senses",
            )
            if common > 1:
                divisor = next(p for p in active if common % p == 0)
                pair = (divisor, n // divisor)
                self._record(
                    "reconstruct-origin", (n,) + pair,
                    f"{n}={pair[0]}*{pair[1]}; replace object by origins",
                )
                return pair
        elif active:
            divisor = active[0]
            self._record(
                "act", (n, divisor, n % divisor),
                f"apply installed mod-{divisor} sensor",
            )
            if n % divisor == 0:
                pair = (divisor, n // divisor)
                self._record(
                    "reconstruct-origin", (n,) + pair,
                    f"{n}={pair[0]}*{pair[1]}; replace object by origins",
                )
                return pair
        self._record(
            "frontier", (n,),
            f"no equal grouping through {isqrt(n)}; n is prime",
        )
        return None


def run(encounters: Iterable[int]) -> ArithmeticLife:
    life = ArithmeticLife()
    for n in encounters:
        life.factor(n)
    return life


def main() -> None:
    life = run((91, 97, 143))
    for index, event in enumerate(life.events):
        print(f"{index:02d} {event.kind:18} {event.subject}  {event.detail}")
    print(f"\ninstalled senses: {tuple(f'mod {m}' for m in life.moduli)}")
    print("next arithmetic moves use these senses without rediscovery")


if __name__ == "__main__":
    main()
