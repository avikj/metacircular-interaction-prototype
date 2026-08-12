"""Exact finite diagnostics for the closed-unitary syntactic-monoid boundary.

A transformation on {0,...,n-1} is represented by its tuple of outputs.
No numerical linear algebra is needed: a finite transformation monoid has a
faithful closed-unitary representation exactly when all its elements are
permutations.
"""

from __future__ import annotations

from collections.abc import Iterable

Transformation = tuple[int, ...]


def identity(size: int) -> Transformation:
    if size < 0:
        raise ValueError("size must be nonnegative")
    return tuple(range(size))


def validate(transformation: Transformation) -> None:
    size = len(transformation)
    if any(not isinstance(y, int) or y < 0 or y >= size for y in transformation):
        raise ValueError("a transformation must map its finite set to itself")


def compose(left: Transformation, right: Transformation) -> Transformation:
    """Return left after right."""
    if len(left) != len(right):
        raise ValueError("transformations must act on the same set")
    validate(left)
    validate(right)
    return tuple(left[right[x]] for x in range(len(left)))


def generated_monoid(generators: Iterable[Transformation]) -> frozenset[Transformation]:
    generators = tuple(generators)
    if not generators:
        raise ValueError("supply at least one generator to determine the state set")
    size = len(generators[0])
    if any(len(g) != size for g in generators):
        raise ValueError("generators must act on the same set")
    for generator in generators:
        validate(generator)

    known = {identity(size), *generators}
    frontier = list(known)
    while frontier:
        new = frontier.pop()
        for old in tuple(known):
            for product in (compose(new, old), compose(old, new)):
                if product not in known:
                    known.add(product)
                    frontier.append(product)
    return frozenset(known)


def is_bijection(transformation: Transformation) -> bool:
    validate(transformation)
    return len(set(transformation)) == len(transformation)


def is_group(monoid: Iterable[Transformation]) -> bool:
    """Criterion for a finite transformation monoid already closed under product."""
    monoid = tuple(monoid)
    return bool(monoid) and all(is_bijection(element) for element in monoid)


def faithful_closed_unitary_possible(monoid: Iterable[Transformation]) -> bool:
    """The theorem: for a finite monoid, faithful closed-unitary iff group."""
    return is_group(monoid)


def idempotents(monoid: Iterable[Transformation]) -> frozenset[Transformation]:
    monoid = tuple(monoid)
    return frozenset(element for element in monoid if compose(element, element) == element)


def coherent_environment_dimension(transformation: Transformation) -> int:
    """Minimum garbage dimension for |x> -> |f(x)>|g_x>."""
    validate(transformation)
    if not transformation:
        return 0
    fibers = [0] * len(transformation)
    for output in transformation:
        fibers[output] += 1
    return max(fibers)
