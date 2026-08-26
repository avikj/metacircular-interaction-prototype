#!/usr/bin/env python3
"""Independent exhaustive audit of LENS_ORDER_COMMUTATION.

This intentionally imports nothing from ``lens_commutation``.  It constructs
partition projections, products, joins, and the block criterion afresh.
"""

from fractions import Fraction
import unittest


def partitions(n):
    """Restricted-growth encodings of every partition of range(n)."""
    if n == 0:
        yield ()
        return

    def extend(prefix, maximum):
        if len(prefix) == n:
            yield tuple(prefix)
            return
        for label in range(maximum + 2):
            yield from extend(prefix + [label], max(maximum, label))

    yield from extend([0], 0)


def blocks(labels):
    result = {}
    for point, label in enumerate(labels):
        result.setdefault(label, []).append(point)
    return tuple(tuple(points) for points in result.values())


def projection(labels):
    n = len(labels)
    members = {x: tuple(y for y in range(n) if labels[y] == labels[x]) for x in range(n)}
    return tuple(
        tuple(Fraction(int(y in members[x]), len(members[x])) for y in range(n))
        for x in range(n)
    )


def multiply(left, right):
    n = len(left)
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(n)) for j in range(n))
        for i in range(n)
    )


def join_labels(pi, sigma):
    n = len(pi)
    adjacency = [set() for _ in range(n)]
    for labels in (pi, sigma):
        for block in blocks(labels):
            for x in block:
                adjacency[x].update(block)
    output = [-1] * n
    component = 0
    for start in range(n):
        if output[start] >= 0:
            continue
        stack = [start]
        output[start] = component
        while stack:
            x = stack.pop()
            for y in adjacency[x]:
                if output[y] < 0:
                    output[y] = component
                    stack.append(y)
        component += 1
    return tuple(output)


def block_criterion(pi, sigma):
    joined = join_labels(pi, sigma)
    for E in blocks(joined):
        Eset = set(E)
        pi_blocks = [set(B) for B in blocks(pi) if set(B) <= Eset]
        sigma_blocks = [set(D) for D in blocks(sigma) if set(D) <= Eset]
        for B in pi_blocks:
            for D in sigma_blocks:
                if len(B & D) * len(E) != len(B) * len(D):
                    return False
    return True


class LensCommutationIndependentAudit(unittest.TestCase):
    def test_every_partition_pair_through_five_points(self):
        checked = 0
        for n in range(1, 6):
            universe = tuple(partitions(n))
            for pi in universe:
                P = projection(pi)
                for sigma in universe:
                    Q = projection(sigma)
                    commute = multiply(P, Q) == multiply(Q, P)
                    criterion = block_criterion(pi, sigma)
                    self.assertEqual(commute, criterion, (pi, sigma))
                    if commute:
                        self.assertEqual(multiply(P, Q), projection(join_labels(pi, sigma)))
                    checked += 1
        self.assertEqual(checked, 1 + 4 + 25 + 225 + 2704)

    def test_permutability_without_equidistribution_is_false_control(self):
        pi = (0, 0, 0, 1, 1)
        sigma = (0, 1, 1, 0, 1)
        self.assertTrue(all(set(B) & set(D) for B in blocks(pi) for D in blocks(sigma)))
        self.assertFalse(block_criterion(pi, sigma))
        self.assertNotEqual(
            multiply(projection(pi), projection(sigma)),
            multiply(projection(sigma), projection(pi)),
        )

    def test_crt_specialization_including_shared_factors(self):
        for m, n in ((3, 5), (4, 6), (6, 10), (8, 12), (12, 18)):
            size = m * n
            pi = tuple(x % m for x in range(size))
            sigma = tuple(x % n for x in range(size))
            self.assertTrue(block_criterion(pi, sigma), (m, n))


if __name__ == "__main__":
    unittest.main()
