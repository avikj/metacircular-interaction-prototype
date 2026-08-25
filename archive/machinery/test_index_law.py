#!/usr/bin/env python3

import unittest
from math import ceil

from index_law import (
    dilation_dimension,
    divisibility_predicate,
    fibres,
    index_bound,
    is_balanced,
    is_equivariant_quotient,
    lopsided_bound,
    obeys_index_law,
    residue_chart,
    rolling_step,
)


class TheoremITests(unittest.TestCase):
    def test_both_bounds_hold_for_arbitrary_charts(self):
        for size in range(2, 40):
            for image in range(1, size + 1):
                def chart(x, size=size, image=image):
                    return x % image if x < image * (size // image) else x % image
                grouped = fibres(chart, range(size))
                dimension = dilation_dimension(chart, range(size))
                self.assertGreaterEqual(dimension, index_bound(size, len(grouped)))
                self.assertLessEqual(dimension, lopsided_bound(size, len(grouped)))

    def test_the_lower_bound_is_attained_exactly_when_balanced(self):
        for size in (10, 12, 30, 100):
            for image in (2, 3, 4, 7):
                balanced = lambda x, image=image: x % image
                self.assertTrue(is_balanced(balanced, range(size)))
                self.assertTrue(obeys_index_law(balanced, range(size)))
                self.assertEqual(dilation_dimension(balanced, range(size)),
                                 index_bound(size, image))

    def test_the_upper_bound_is_attained_by_a_lopsided_chart(self):
        for size, image in ((10, 3), (12, 4), (100, 2), (50, 5)):
            def lopsided(x, image=image):
                return x if x < image - 1 else image - 1
            self.assertEqual(dilation_dimension(lopsided, range(size)),
                             lopsided_bound(size, image))
            self.assertFalse(is_balanced(lopsided, range(size)))


class TheoremETests(unittest.TestCase):
    """Equivariance under a transitive group action forces the index exactly."""

    def test_the_rolling_step_is_an_equivariant_quotient(self):
        for prime, height, power in ((2, 4, 1), (2, 4, 3), (3, 3, 1), (3, 3, 2),
                                     (3, 3, 5), (5, 2, 1)):
            observable, domain = rolling_step(prime, height, power)
            self.assertTrue(is_equivariant_quotient(observable, prime ** height))
            sizes = {len(v) for v in fibres(observable, domain).values()}
            self.assertEqual(len(sizes), 1, f"p={prime} k={height} j={power}")

    def test_equivariance_gives_exactly_the_published_dimension(self):
        for prime, height, power in ((2, 4, 1), (2, 4, 3), (3, 3, 2), (3, 3, 5),
                                     (5, 2, 1)):
            observable, domain = rolling_step(prime, height, power)
            self.assertEqual(dilation_dimension(observable, domain),
                             prime ** min(power, height))
            self.assertTrue(obeys_index_law(observable, domain))


class CorpusInstancesTests(unittest.TestCase):
    """The four published dilation computations are one law."""

    def test_arithmetic_quotient_formula_five(self):
        for size, modulus in ((91, 7), (100, 7), (50, 6), (1000, 13)):
            observable, domain = residue_chart(modulus, size)
            self.assertEqual(dilation_dimension(observable, domain),
                             ceil(size / modulus))
            self.assertTrue(obeys_index_law(observable, domain))

    def test_canonical_depth_memory_theorem_M(self):
        for prime, time in ((3, 26), (3, 27), (7, 91), (5, 124)):
            depth = 0
            while prime ** (depth + 1) <= time:
                depth += 1
            observable = lambda n, m=prime ** depth: n % m
            self.assertEqual(dilation_dimension(observable, range(1, time + 1)),
                             ceil(time / prime ** depth))

    def test_the_only_failure_is_the_only_unbalanced_chart(self):
        for size, modulus in ((100, 7), (200, 5), (300, 11)):
            observable, domain = divisibility_predicate(modulus, size)
            self.assertFalse(is_balanced(observable, domain))
            self.assertFalse(obeys_index_law(observable, domain))
            self.assertGreater(dilation_dimension(observable, domain),
                               index_bound(size, 2))

    def test_the_failure_is_the_complement_class_as_session_nine_said(self):
        """REFINING_DILATION estimated about N(1-1/m); this pins it exactly."""
        for size, modulus in ((100, 7), (200, 5)):
            observable, domain = divisibility_predicate(modulus, size)
            multiples = len([n for n in domain if n % modulus == 0])
            self.assertEqual(dilation_dimension(observable, domain),
                             size - multiples)


if __name__ == "__main__":
    unittest.main()
