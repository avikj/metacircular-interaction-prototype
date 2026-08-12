"""Minimal selectable intervention added to autonomous multiplier reuse."""

from itertools import product

from mod5_predictive_quantum_profile import signature


def observe(x: int) -> str:
    x %= 5
    return "zero" if x == 0 else "one" if x == 1 else "other"


def mixed_signature(installed: int, foreign: int, max_autonomous_power: int = 4):
    """All words formed from self-use a and selectable left action b.

    Commutativity reduces every word to b^i a^j. Powers through four suffice
    in Z/5Z (including zero separately).
    """
    installed %= 5
    foreign %= 5
    autonomous = signature(installed, max_autonomous_power)
    mixed = tuple(
        observe(pow(foreign, i, 5) * pow(installed, j, 5))
        for i, j in product(range(5), repeat=2)
    )
    return autonomous + mixed


def mixed_classes(foreign: int):
    by_signature = {}
    for installed in range(5):
        by_signature.setdefault(mixed_signature(installed, foreign), set()).add(installed)
    return frozenset(frozenset(values) for values in by_signature.values())


def mixed_dimension(foreign: int) -> int:
    return len(mixed_classes(foreign))


def capability_changing_controls():
    return frozenset(b for b in range(5) if mixed_dimension(b) > 4)
