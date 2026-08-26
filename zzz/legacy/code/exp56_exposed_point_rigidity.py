#!/usr/bin/env python3
"""Exact falsifiers for EXPOSED_POINT_RIGIDITY / R0019.

Every arithmetic check in this file uses integers or Fraction.  The symbolic
infinite exposed-point theorem is proved in the note; this program only replays
the declared finite witnesses and controls.
"""

from fractions import Fraction as F
import itertools


if not __debug__:
    raise SystemExit("exp56 requires assertions; do not run Python with -O")


passed = 0


def check(name, condition):
    global passed
    assert condition, name
    passed += 1
    print(f"PASS {name}")


def dirichlet_polynomial(coefficients, s):
    return sum(F(c, n**s) for n, c in coefficients.items())


# H1+: normalized witness; no n=1 coefficient is changed.
p0 = {2: -28, 3: 243, 4: -320}
check("H1+: P0(2) = 0 exactly", dirichlet_polynomial(p0, 2) == 0)
check("H1+: P0(4) = 0 exactly", dirichlet_polynomial(p0, 4) == 0)
check("H1+: P0(3) = 1/2 exactly", dirichlet_polynomial(p0, 3) == F(1, 2))
check("H1+ control: P0 is normalized at n=1", 1 not in p0)


# H2+: equality of the load-bearing local factors; the remaining prime tail is
# identical on both globally defined completely multiplicative functions.
def local_euler_value(a2, a3):
    return 1 / ((1 - F(a2, 4)) * (1 - F(a3, 9)))


check(
    "H2+: (1,1) and (0,3) have local value 3/2",
    local_euler_value(1, 1) == local_euler_value(0, 3) == F(3, 2),
)
check("H2+ control: b(3)=3 violates the unit-disk bound", abs(3) > 1)


# Wrong-witness control.
wrong = {2: -28, 3: 243, 4: -319}
check(
    "H1+ control: changing -320 to -319 breaks s=4",
    dirichlet_polynomial(wrong, 4) != 0,
)


def differences(points):
    return tuple(
        sorted(abs(x - y) for x, y in itertools.combinations(points, 2))
    )


def canonical(points):
    translated = tuple(sorted(x - min(points) for x in points))
    reflected = tuple(sorted(max(translated) - x for x in translated))
    return min(translated, reflected)


empty_sizes = []
first_pair = None
for size in range(3, 7):
    fibers = {}
    for points in itertools.combinations(range(18), size):
        fibers.setdefault(differences(points), set()).add(canonical(points))
    collisions = [
        (diff, sorted(classes))
        for diff, classes in fibers.items()
        if len(classes) > 1
    ]
    if collisions:
        first_pair = (size, sorted(collisions)[0])
        break
    empty_sizes.append(size)


size, (shared_differences, pair) = first_pair
expected_a = (0, 1, 2, 6, 8, 11)
expected_b = (0, 1, 6, 7, 9, 11)
check("H4+: no finite-subset collision at sizes 3-5", empty_sizes == [3, 4, 5])
check("H4+: first collision size is 6", size == 6)
check(
    "H4+: advertised pair has equal difference multisets",
    differences(expected_a) == differences(expected_b),
)
check(
    "H4+: advertised pair is inequivalent under translation/reflection",
    canonical(expected_a) != canonical(expected_b),
)
check(
    "H4+: advertised shared multiset is exact",
    differences(expected_a)
    == (1, 1, 2, 2, 3, 4, 5, 5, 6, 6, 7, 8, 9, 10, 11),
)

print(f"\nALL {passed} EXACT CHECKS PASS")
