#!/usr/bin/env python3
"""Exact tests for the unified confinement index.

Run: python3 -m unittest test_unified_confinement -v   (from machinery/)
"""

import unittest

from multiplicative_confinement import confinement as odd_confinement
from two_adic_confinement import confinement as two_confinement
from unified_confinement import (
    UnifiedIndex,
    level,
    minimal_level,
    principal_part_is_cyclic,
    tame_index,
    tame_modulus,
    unified_index,
    unit_closure,
    valuation,
)

ODD_CASES = [(3, 4), (3, 5), (5, 3), (5, 4), (7, 3), (7, 4), (11, 3), (13, 3)]
GENERATOR_SETS = ((2,), (3,), (4,), (5,), (7,), (9,), (2, 3), (3, 5))


class UnifiedConfinementTests(unittest.TestCase):
    def test_formula_holds_for_odd_prime_powers(self):
        checked = 0
        for p, k in ODD_CASES:
            for gens in GENERATOR_SETS:
                if any(g % p == 0 for g in gens):
                    continue
                record = unified_index(gens, p, k)
                self.assertEqual(record.index, record.predicted,
                                 f"p={p} k={k} gens={gens}")
                checked += 1
        self.assertGreater(checked, 40)

    def test_formula_holds_at_two(self):
        checked = 0
        for k in (3, 4, 6, 8, 10):
            for gens in ((3,), (5,), (7,), (9,), (17,), (31,), (15,), (3, 5)):
                record = unified_index(gens, 2, k)
                self.assertEqual(record.index, record.predicted,
                                 f"k={k} gens={gens}")
                checked += 1
        self.assertGreater(checked, 35)

    def test_the_exception_is_exactly_the_value_of_T(self):
        """T = p for odd p, 4 for p = 2, and l_min = v_p(T)."""
        for p in (3, 5, 7, 11, 13):
            self.assertEqual(tame_modulus(p), p)
            self.assertEqual(minimal_level(p), 1)
        self.assertEqual(tame_modulus(2), 4)
        self.assertEqual(minimal_level(2), 2)

    def test_T_is_the_least_modulus_making_the_principal_part_cyclic(self):
        """That is the whole reason the p = 2 case looked exceptional."""
        for p, k in ((3, 4), (5, 3), (7, 3), (2, 6), (2, 8)):
            self.assertTrue(principal_part_is_cyclic(p, k))
        # with T = 2 at p = 2 the principal part is all odd residues, and
        # (Z/2^k)^* is not cyclic for k >= 3
        for k in (3, 4, 6):
            odd = [x for x in range(1, 2**k, 2)]
            orders = []
            for g in odd:
                order, x = 1, g
                while x != 1:
                    x = x * g % 2**k
                    order += 1
                orders.append(order)
            self.assertLess(max(orders), len(odd))     # no generator

    def test_agrees_with_both_earlier_notes(self):
        """One formula reproduces the two special-case results."""
        for q in (7, 17, 31, 41, 73, 97):
            for gens in ((2, 3), (2,), (3,)):
                mine = unified_index(gens, q, 1).index
                theirs = odd_confinement(gens, q).index
                self.assertEqual(mine, theirs, f"q={q} gens={gens}")
        for k in (4, 6, 8, 10):
            for gens in ((3,), (5,), (7,), (17,), (31,), (3, 5)):
                mine = unified_index(gens, 2, k).index
                theirs = two_confinement(gens, k).index
                self.assertEqual(mine, theirs, f"k={k} gens={gens}")

    def test_subgroup_order_factors_as_tame_times_wild(self):
        for p, k in ((3, 4), (5, 3), (2, 8)):
            for gens in ((3,), (5,), (7,)):
                if any(g % p == 0 for g in gens):
                    continue
                record = unified_index(gens, p, k)
                subgroup = unit_closure(gens, p, k)
                tame_order = (p - 1) // record.tame_index if p > 2 \
                    else 2 // record.tame_index
                wild_order = p ** (k - record.level)
                self.assertEqual(record.subgroup_order, tame_order * wild_order)

    def test_known_false_control_one_T_fits_all(self):
        """'T = p works at every prime' must fire as false."""
        # at p = 2 with T = 2 the level would be v_2(x-1) over ALL odd x,
        # which is 1 for x = 3, so the formula would predict index 2^(1-1) = 1
        subgroup = unit_closure((3,), 2, 8)
        naive_level = min(valuation(x - 1, 2) for x in subgroup if x != 1)
        self.assertEqual(naive_level, 1)                 # would give index 1
        self.assertEqual(unified_index((3,), 2, 8).index, 2)   # truth is 2
        self.assertNotEqual(2 ** (naive_level - 1), 2)

    def test_shape_and_rejections(self):
        record = unified_index((3,), 5, 3)
        self.assertIsInstance(record, UnifiedIndex)
        with self.assertRaises(Exception):
            record.index = 0
        with self.assertRaises(ValueError):
            unit_closure((5,), 5, 3)          # not a unit
        with self.assertRaises(ValueError):
            unit_closure((2,), 3, 0)
        with self.assertRaises(ValueError):
            tame_modulus(1)
        with self.assertRaises(ValueError):
            valuation(0, 3)


if __name__ == "__main__":
    unittest.main()
