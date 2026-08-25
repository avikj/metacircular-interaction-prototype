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


@dataclass(frozen=True)
class OriginJoin:
    inputs: tuple[int, int]
    remembered_origins: tuple[tuple[int, ...], tuple[int, ...]]
    overlap: int
    least_common_multiple: int
    embeddings: tuple[int, int]


class ArithmeticLife:
    """A tiny process whose installed observations change its next action."""

    def __init__(self) -> None:
        self.moduli: list[int] = []
        self.generated_through = 1
        self.batch_compiled = False
        self.factor_origins: dict[int, tuple[int, int]] = {}
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
        """Let the current sensor frontier grow until equal grouping resolves n.

        Two regimes actually execute.  Before the batch theorem is derived,
        every installed sensor below the frontier is applied as its own
        reduction.  Deriving the theorem replaces those |A| reductions by one
        Euclidean descent, and the trace records the change of regime rather
        than asserting it.
        """
        if n < 2:
            raise ValueError("factor encounter needs n >= 2")
        bound = isqrt(n)
        self._extend_prime_sensors_through(bound, n)
        active = sorted(m for m in self.moduli if m <= bound)
        witness = None
        if active and self.batch_compiled:
            wheel = prod(active)
            common = gcd(n, wheel)
            self._record(
                "act-batch", (n, wheel, common),
                "one Euclidean descent interrogates every installed sense",
            )
            if common > 1:
                # Least active modulus dividing the overlap; minimality forces
                # it prime, so the origin is irreducible even under injected
                # composite sensors.  See ARITHMETIC_LIFE_ADVERSARIAL_AUDIT T3.
                witness = min(m for m in active if common % m == 0)
        elif active:
            residues = tuple(n % m for m in active)
            for modulus, residue in zip(active, residues):
                self._record(
                    "act", (n, modulus, residue),
                    f"apply installed mod-{modulus} sensor on its own",
                )
            hits = [m for m, r in zip(active, residues) if r == 0]
            if hits:
                witness = hits[0]
            if len(active) >= 2:
                self._record(
                    "compile-action", tuple(active) + (prod(active),),
                    f"gcd(n,product of senses)>1 iff some installed sense "
                    f"divides n; {len(active)} separate reductions collapse "
                    "into one Euclidean descent from here on",
                )
                self.batch_compiled = True
        if witness is not None:
            pair = (witness, n // witness)
            self.factor_origins[n] = pair
            self._record(
                "reconstruct-origin", (n,) + pair,
                f"{n}={pair[0]}*{pair[1]}; replace object by irreducible origins",
            )
            return pair
        self._record(
            "frontier", (n,),
            f"no equal grouping through {bound}; n is prime",
        )
        return None

    def join_origins(self, left: int, right: int) -> OriginJoin:
        """Form the least shared multiple by Euclidean descent alone.

        Dividing the overlap out before multiplication prevents double-counting
        the shared origin.  Remembered origins are *provenance*, not input: the
        identity gcd(a,b)*lcm(a,b)=ab makes the join independent of any
        factorization, so requiring stored origins would only shrink the domain
        (it refused prime arguments) without contributing to the value.
        """
        if left < 1 or right < 1:
            raise ValueError("a join needs positive integers")
        overlap = gcd(left, right)
        joined = (left // overlap) * right
        embeddings = (joined // left, joined // right)
        if joined % left or joined % right:
            raise AssertionError("formed join is not a common multiple")
        self._record(
            "form-operation",
            (left, right, overlap, joined) + embeddings,
            "Euclidean overlap plus factor origins forms lcm; "
            "future common-multiple questions use the join",
        )
        return OriginJoin(
            inputs=(left, right),
            remembered_origins=(
                self.factor_origins.get(left, ()),
                self.factor_origins.get(right, ()),
            ),
            overlap=overlap,
            least_common_multiple=joined,
            embeddings=embeddings,
        )


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
