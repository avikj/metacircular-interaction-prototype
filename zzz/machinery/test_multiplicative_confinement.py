#!/usr/bin/env python3
"""Exact tests for shape-sensitive multiplicative confinement.

Run: python3 -m unittest test_multiplicative_confinement -v   (from machinery/)
"""

import unittest
from math import gcd

from multiplicative_confinement import (
    Confinement,
    additive_escape,
    confinement,
    index_table,
    interval_generates_everything,
    least_primitive_root,
    multiplicative_closure,
    subgroup_order_by_index,
)

PRIMES = (7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 73, 97, 193, 241)


class MultiplicativeConfinementTests(unittest.TestCase):
    def test_closure_is_a_subgroup(self):
        """Closed under multiplication and inverses, and contains 1."""
        for q in PRIMES:
            closure = multiplicative_closure((2, 3), q)
            self.assertIn(1, closure)
            for x in closure:
                for y in closure:
                    self.assertIn(x * y % q, closure)
                # the inverse is a positive power, hence present
                self.assertIn(pow(x, q - 2, q), closure)
            self.assertEqual((q - 1) % len(closure), 0)   # Lagrange

    def test_index_calculus_agrees_with_enumeration(self):
        """Gauss art. 57 computes the order without enumerating the subgroup."""
        for q in PRIMES:
            for gens in ((2,), (3,), (2, 3), (2, 3, 5)):
                if any(g % q == 0 for g in gens):
                    continue
                self.assertEqual(subgroup_order_by_index(gens, q),
                                 len(multiplicative_closure(gens, q)))

    def test_index_table_is_a_discrete_logarithm(self):
        for q in (17, 41, 97):
            root = least_primitive_root(q)
            table = index_table(q, root)
            self.assertEqual(len(table), q - 1)
            for x, e in table.items():
                self.assertEqual(pow(root, e, q), x % q)

    def test_the_locus_is_confined_at_these_primes(self):
        """Half of all classes unreachable at ANY multiplicative chain length."""
        for q in (73, 97, 193, 241):
            c = confinement((2, 3), q)
            self.assertEqual(c.index, 2)
            self.assertAlmostEqual(c.unreachable_fraction, 0.5, places=9)
            self.assertEqual(c.subgroup_order * 2, c.group_order)
        # and unconfined at these
        for q in (7, 17, 31, 41):
            self.assertEqual(confinement((2, 3), q).index, 1)

    def test_gauss_own_modulus_97(self):
        """Gauss tabulated indices to modulus 97; the gcd is 2."""
        table = index_table(97)
        self.assertEqual(least_primitive_root(97), 5)
        self.assertEqual(table[2], 34)
        self.assertEqual(table[3], 70)
        self.assertEqual(gcd(gcd(96, 34), 70), 2)
        c = confinement((2, 3), 97)
        self.assertEqual(c.subgroup_order, 48)
        self.assertEqual(c.group_order, 96)

    def test_shape_beats_cardinality(self):
        """A five-element interval reaches everything an infinite locus cannot."""
        for q in (73, 97, 193):
            c = confinement((2, 3), q)
            self.assertLess(c.subgroup_order, c.group_order)     # locus confined
            root = c.primitive_root
            self.assertTrue(interval_generates_everything(root, q))
            self.assertLessEqual(root, 7)                        # a tiny interval
        # the point stated as a comparison: 5 elements beat a locus of any size
        self.assertTrue(interval_generates_everything(5, 97))
        self.assertEqual(len(multiplicative_closure(range(1, 6), 97)), 96)

    def test_addition_dissolves_the_confinement(self):
        """Section 3: with + admitted, shape obstructs nothing."""
        for q in (73, 97, 193, 241):
            steps = additive_escape((2, 3), q)
            self.assertGreater(steps, 0)
            self.assertLess(steps, 10)         # a handful of +1 steps suffice
        for q in (7, 17, 31, 41):
            self.assertEqual(additive_escape((2, 3), q), 0)   # nothing to escape

    def test_known_false_control_counting_can_see_this(self):
        """'a cardinality bound could have given this' must fire as false."""
        # the locus below any ceiling X has some finite size f; an interval of
        # the SAME size reaches every class, while the locus never does.
        q = 97
        c = confinement((2, 3), q)
        for f in (5, 20, 96):
            interval = multiplicative_closure(range(1, f + 1), q)
            self.assertEqual(len(interval), 96)                # unconfined
            self.assertEqual(c.subgroup_order, 48)             # confined
        # so no function of cardinality alone can distinguish them
        self.assertNotEqual(len(multiplicative_closure(range(1, 6), q)),
                            c.subgroup_order)

    def test_shape_and_rejections(self):
        c = confinement((2, 3), 97)
        self.assertIsInstance(c, Confinement)
        with self.assertRaises(Exception):
            c.index = 0
        with self.assertRaises(ValueError):
            multiplicative_closure((2,), 1)
        with self.assertRaises(ValueError):
            multiplicative_closure((97,), 97)      # not a unit
        with self.assertRaises(ValueError):
            least_primitive_root(2)
        with self.assertRaises(ValueError):
            interval_generates_everything(0, 97)


if __name__ == "__main__":
    unittest.main()
