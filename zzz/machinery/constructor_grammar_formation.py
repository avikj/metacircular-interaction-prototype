#!/usr/bin/env python3
"""Form observations as least-cost programs, not entries in a catalog."""

from __future__ import annotations

from dataclasses import dataclass
from heapq import heappop, heappush
from typing import Callable


@dataclass(frozen=True)
class Constructor:
    name: str
    cost: int
    apply: Callable[[int], int]


@dataclass(frozen=True)
class Formation:
    collision: tuple[int, int]
    modulus: int
    cost: int
    origin: int
    derivation: tuple[tuple[str, int, int], ...]

    def replay(self) -> int:
        value = self.origin
        for name, before, after in self.derivation:
            if before != value:
                raise ValueError(f"broken certificate before {name}")
            value = after
        if value != self.modulus:
            raise ValueError("certificate does not reach formed modulus")
        return value


class QuotientGrammar:
    """Programs `mod m`, generated from installed moduli by constructors."""

    def __init__(self, installed: tuple[int, ...] = (2,)) -> None:
        self.installed = set(installed)
        self.constructors = (
            Constructor("increment-modulus", 1, lambda m: m + 1),
            Constructor("double-modulus", 1, lambda m: 2 * m),
        )
        self.formations: list[Formation] = []

    @staticmethod
    def separates(modulus: int, left: int, right: int) -> bool:
        return left % modulus != right % modulus

    def form_for_collision(self, left: int, right: int) -> Formation:
        if left == right:
            raise ValueError("equal values cannot be separated")
        if any(self.separates(m, left, right) for m in self.installed):
            raise ValueError("an installed observation already separates the pair")

        # m > |a-b| always separates, so this finite ceiling loses no optimum.
        ceiling = max(max(self.installed), abs(left - right) + 1)
        distance = {m: 0 for m in self.installed}
        predecessor: dict[int, tuple[int, str]] = {}
        queue = [(0, m) for m in sorted(self.installed)]

        while queue:
            cost, modulus = heappop(queue)
            if cost != distance[modulus]:
                continue
            if self.separates(modulus, left, right):
                path: list[tuple[str, int, int]] = []
                cursor = modulus
                while cursor in predecessor:
                    before, name = predecessor[cursor]
                    path.append((name, before, cursor))
                    cursor = before
                result = Formation(
                    collision=(left, right),
                    modulus=modulus,
                    cost=cost,
                    origin=cursor,
                    derivation=tuple(reversed(path)),
                )
                result.replay()
                self.installed.add(modulus)
                self.formations.append(result)
                return result
            for constructor in self.constructors:
                target = constructor.apply(modulus)
                if target < 2 or target > ceiling:
                    continue
                candidate = cost + constructor.cost
                if candidate < distance.get(target, 10**18):
                    distance[target] = candidate
                    predecessor[target] = (modulus, constructor.name)
                    heappush(queue, (candidate, target))
        raise AssertionError("finite separating modulus was not reached")


def accidental_catalog_choice(left: int, right: int, catalog: tuple[int, ...]) -> int:
    """Known-false policy control: call order silently chooses the observation."""
    return next(m for m in catalog if left % m != right % m)


def main() -> None:
    grammar = QuotientGrammar()
    formation = grammar.form_for_collision(14, 26)
    print("collision:", formation.collision)
    print("formed program: mod", formation.modulus)
    print("program cost:", formation.cost)
    print("derivation:", formation.derivation)
    print("catalog call-order control:", accidental_catalog_choice(14, 26, (7, 5)))


if __name__ == "__main__":
    main()
