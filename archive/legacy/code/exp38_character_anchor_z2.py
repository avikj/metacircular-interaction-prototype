#!/usr/bin/env python3
"""Exhaustive falsification search for character-anchor rigidity in Z^2.

Enumerates all nonempty subsets of {0,1,2,3}^2, groups them by their full
oriented difference multiplicity, and checks that every homometric mate of a
set with a singleton mod-2 character fiber is translation/inversion
equivalent to it.  Exact integer arithmetic; no external dependencies.
"""

from collections import Counter, defaultdict


SIDE = 4
POINTS = tuple((x, y) for x in range(SIDE) for y in range(SIDE))
CHARACTERS = {
    "x": lambda p: (p[0] & 1),
    "y": lambda p: (p[1] & 1),
    "x+y": lambda p: ((p[0] + p[1]) & 1),
}


def signature(points):
    """Hashable full group-labeled oriented autocorrelation."""
    counts = Counter(
        (a[0] - b[0], a[1] - b[1]) for a in points for b in points
    )
    return tuple(sorted(counts.items()))


def translate_normal_form(points):
    """Canonical representative up to translation."""
    ordered = sorted(points)
    return min(
        tuple(sorted((x - ax, y - ay) for x, y in ordered))
        for ax, ay in ordered
    )


def dihedral_normal_form(points):
    """Canonical representative up to translation and central inversion."""
    direct = translate_normal_form(points)
    reflected = translate_normal_form([(-x, -y) for x, y in points])
    return min(direct, reflected)


def singleton_fiber(points, character):
    odd = sum(character(p) for p in points)
    even = len(points) - odd
    return odd == 1 or even == 1


def main():
    families = defaultdict(list)
    for mask in range(1, 1 << len(POINTS)):
        subset = tuple(POINTS[i] for i in range(len(POINTS)) if mask >> i & 1)
        families[signature(subset)].append(subset)

    print(f"grid={SIDE}x{SIDE}")
    print(f"all_nonempty_sets={(1 << len(POINTS)) - 1}")
    print(f"signature_classes={len(families)}")

    for name, character in CHARACTERS.items():
        anchored = 0
        bad_families = 0
        for family in families.values():
            anchored_members = [
                subset for subset in family if singleton_fiber(subset, character)
            ]
            anchored += len(anchored_members)
            if not anchored_members:
                continue
            forms = {dihedral_normal_form(subset) for subset in family}
            if len(forms) != 1:
                bad_families += 1
        print(
            f"character={name!r} anchored_sets={anchored} "
            f"bad_families={bad_families}"
        )


if __name__ == "__main__":
    main()
