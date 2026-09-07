#!/usr/bin/env python3
"""Exact tests for admitting infinite valuation.

The decisive test is `test_criterion_needs_no_deletion_once_infinity_is_a_value`:
it is exactly the comparison that FAILED last turn and forced me to delete
`V(f)` from the world.  With `v_p(0) = infinity` admitted, it passes.
"""

import itertools
import math
import random
import unittest

from infinite_valuation import (
    IDENT,
    INF,
    SUM,
    evaluate,
    gradient,
    hyperplane,
    least_depth_ext,
    stabilization_radius_ext,
    transports_by_search_ext,
    transports_by_tangent_undeleted,
    vp_ext,
)

POLYS = (
    (SUM, "X+Y"),
    ({(2, 0): 1, (0, 1): 1}, "X^2+Y"),
    ({(1, 1): 1, (0, 0): 3}, "XY+3"),
    ({(1, 0): 2, (0, 1): 3, (1, 1): 1}, "2X+3Y+XY"),
    ({(1, 0): 1, (0, 1): -1}, "X-Y"),
)


class ExtendedValuationTests(unittest.TestCase):
    def test_zero_has_infinite_valuation(self):
        for p in (2, 3, 5):
            self.assertEqual(vp_ext(0, p), INF)
            self.assertTrue(math.isinf(vp_ext(0, p)))

    def test_agrees_with_the_ordinary_valuation_elsewhere(self):
        for p in (2, 3, 5):
            for n in range(1, 200):
                v = 0
                m = n
                while m % p == 0:
                    m //= p
                    v += 1
                self.assertEqual(vp_ext(n, p), float(v))
                self.assertEqual(vp_ext(-n, p), float(v))


class NoDeletionNeededTests(unittest.TestCase):
    def test_the_exact_case_that_forced_the_deletion(self):
        """`p=2`, `f=X+Y`, `x=(-9,-7)`: both hyperplane directions land on
        `f=0`.  Last turn that was a false positive; with `infinity` admitted
        the zeros are genuine witnesses and criterion and search agree."""
        p, x = 2, (-9, -7)
        world = [(a, b) for a in range(-9, 10) for b in range(-9, 10)]
        self.assertEqual(int(vp_ext(evaluate(SUM, x), p)), 4)
        self.assertTrue(transports_by_tangent_undeleted(world, SUM, x, p))
        self.assertTrue(transports_by_search_ext(world, SUM, x, p))
        # and the witnesses really are zeros
        zeros = [
            y
            for y in world
            if evaluate(SUM, y) == 0 and all((a - b) % 16 == 0 for a, b in zip(y, x))
        ]
        self.assertTrue(zeros)

    def test_criterion_needs_no_deletion_once_infinity_is_a_value(self):
        """The decisive comparison, over a box and many polynomials, with
        `V(f)` LEFT IN the world on both sides."""
        world = [(a, b) for a in range(-9, 10) for b in range(-9, 10)]
        seen = {True: 0, False: 0}
        for p in (2, 3, 5):
            for f, name in POLYS:
                for x in world:
                    val = evaluate(f, x)
                    if val == 0 or vp_ext(val, p) < 1:
                        continue
                    got = transports_by_tangent_undeleted(world, f, x, p)
                    seen[got] += 1
                    self.assertEqual(
                        got, transports_by_search_ext(world, f, x, p), (name, p, x)
                    )
        self.assertGreater(seen[True], 20)
        self.assertGreater(seen[False], 0)

    def test_also_on_sparse_random_worlds(self):
        rng = random.Random(77)
        for _ in range(200):
            p = rng.choice([2, 3, 5])
            f, _n = rng.choice(POLYS)
            world = [
                (rng.randrange(-14, 15), rng.randrange(-14, 15))
                for _ in range(rng.randrange(4, 30))
            ]
            for x in world:
                val = evaluate(f, x)
                if val == 0 or vp_ext(val, p) < 1:
                    continue
                self.assertEqual(
                    transports_by_tangent_undeleted(world, f, x, p),
                    transports_by_search_ext(world, f, x, p),
                    (p, x),
                )


class ZeroLocusIsTheInfiniteFiberTests(unittest.TestCase):
    def test_depth_is_infinite_exactly_on_the_zero_locus(self):
        for p in (2, 3):
            for f, name in POLYS:
                for x in itertools.product(range(-6, 7), repeat=2):
                    d = least_depth_ext(f, x, p)
                    if evaluate(f, x) == 0:
                        self.assertTrue(math.isinf(d), (name, p, x))
                    else:
                        self.assertFalse(math.isinf(d), (name, p, x))

    def test_depth_e_plus_one_still_suffices_off_the_zero_locus(self):
        """No zero can share `x`'s depth-`(e+1)` chart, so admitting infinity
        does not raise the ambient depth anywhere."""
        for p in (2, 3, 5):
            for f, name in POLYS:
                for x in itertools.product(range(-6, 7), repeat=2):
                    val = evaluate(f, x)
                    if val == 0:
                        continue
                    e = int(vp_ext(val, p))
                    d = least_depth_ext(f, x, p)
                    self.assertLessEqual(d, e + 1, (name, p, x))

    def test_no_zero_shares_the_depth_e_plus_one_chart(self):
        """The mechanism: `y = x (mod p^{e+1})` forces
        `f(y) = f(x) (mod p^{e+1})`, and `f(x) = p^e u` is nonzero there."""
        for p in (2, 3):
            for f, name in POLYS:
                for x in itertools.product(range(-5, 6), repeat=2):
                    val = evaluate(f, x)
                    if val == 0:
                        continue
                    e = int(vp_ext(val, p))
                    m = p ** (e + 1)
                    for h in itertools.product(range(-3, 4), repeat=2):
                        y = tuple(xi + hi * m for xi, hi in zip(x, h))
                        self.assertNotEqual(evaluate(f, y), 0, (name, p, x, h))


class BudgetLosesTheFactorTests(unittest.TestCase):
    def test_waiting_radius_becomes_p_to_the_e(self):
        """`JET_STABILIZATION` §3 gave `(p-1)p^e` because `y=0` was excluded.
        Readmitting it gives exactly `p^e`."""
        for p in (3, 5):
            for e in (1, 2, 3):
                x = p**e
                self.assertEqual(
                    stabilization_radius_ext(IDENT, x, p, 5000), p**e
                )

    def test_the_excluded_witness_was_exactly_zero(self):
        for p in (3, 5):
            for e in (1, 2, 3):
                x = p**e
                y = x + (-1) * p**e  # the t = -1 candidate
                self.assertEqual(y, 0)
                self.assertTrue(math.isinf(vp_ext(y, p)))


if __name__ == "__main__":
    unittest.main()
