#!/usr/bin/env python3
"""Exact tests for the typed cost of building a critical witness.

Run: python3 -m unittest test_witness_chains -v   (from machinery/)
"""

import math
import unittest

from witness_chains import (
    CostComparison,
    am_lower_bound,
    binary_addition_chain,
    binary_addition_length,
    chain_count_bound,
    compare,
    generic_lower_bound,
    is_valid_chain,
    max_reachable,
    power_chain,
    power_chain_length,
    reachable_in_steps,
    shortest_am_chain,
)


class WitnessChainTests(unittest.TestCase):
    def test_codex_ananta_formula_matches_its_construction(self):
        """msg 0164: length is floor(log2 r) + popcount(r) - 1."""
        for r in range(1, 3000):
            chain = binary_addition_chain(r)
            self.assertEqual(chain[-1], r)
            self.assertTrue(is_valid_chain(chain, allow_multiplication=False))
            self.assertEqual(len(chain) - 1, binary_addition_length(r))

    def test_power_chain_is_valid_and_correct(self):
        """Square-and-multiply on the exponent builds p^e with earned ops."""
        for p in (2, 3, 5, 7, 11):
            for e in range(1, 18):
                chain = power_chain(p, e)
                self.assertEqual(chain[-1], p**e)
                self.assertTrue(is_valid_chain(chain, allow_multiplication=True))
                self.assertEqual(len(chain) - 1, power_chain_length(p, e))

    def test_exhaustive_shortest_chains(self):
        """Exact minima by exhaustive search -- proof for these values."""
        expected = {16: 3, 32: 4, 27: 4, 81: 4, 25: 4, 125: 5, 64: 4,
                    243: 5, 17: 4, 3: 2, 5: 3, 7: 4}
        for r, length in expected.items():
            found, chain = shortest_am_chain(r, cap=8)
            self.assertEqual(found, length, f"r={r}")
            self.assertEqual(chain[-1], r)
            self.assertTrue(is_valid_chain(chain, allow_multiplication=True))

    def test_absolute_floor_holds(self):
        """l_{+x}(r) >= ceil(log2 log2 r) + 1, each step at most squaring."""
        for r in list(range(2, 130)) + [243, 256, 500]:
            found, _ = shortest_am_chain(r, cap=9)
            self.assertIsNotNone(found, f"r={r}")
            self.assertGreaterEqual(found, am_lower_bound(r), f"r={r}")

    def test_max_reachable_is_the_true_ceiling(self):
        """The pruning bound must not exclude anything actually reachable."""
        for steps in range(0, 5):
            ceiling = max_reachable(1, steps)
            reached = reachable_in_steps(steps, 10**9)
            self.assertLessEqual(max(reached), ceiling)
        self.assertEqual(max_reachable(1, 3), 16)   # 1,2,4,16
        self.assertEqual(max_reachable(1, 4), 256)

    def test_the_exponential_separation(self):
        """A-chain is linear in e, AM-chain logarithmic."""
        for p in (3, 5, 7):
            for k in range(1, 8):
                e = 2**k
                addition = binary_addition_length(p**e)
                multiplicative = power_chain_length(p, e)
                self.assertGreaterEqual(addition, e * math.log2(p) - 1)
                self.assertEqual(multiplicative, binary_addition_length(p) + k)
                if k >= 3:
                    self.assertLess(multiplicative * 2, addition)

    def test_the_special_witness_is_near_optimal(self):
        """p^(2^k) costs within a small additive slack of the absolute floor."""
        for p, e in ((3, 32), (3, 128), (7, 64), (2, 16), (5, 8)):
            c = compare(p, e)
            self.assertLessEqual(c.multiplicative - c.absolute_floor, 2)
            self.assertGreater(c.saving, 0)

    def test_counting_bound_holds_exactly(self):
        """Exhaustive reachable counts stay under the chain-count bound."""
        for steps in range(1, 6):
            exact = len(reachable_in_steps(steps, 10**6))
            self.assertLessEqual(exact, chain_count_bound(steps))
        # and the counts are tiny, so almost no integer is cheap
        self.assertEqual(len(reachable_in_steps(5, 10**6)), 88)
        # the counting bound is asymptotic; it only bites for large ceilings
        self.assertLess(generic_lower_bound(10**6), 3)
        self.assertGreater(generic_lower_bound(10**30), 7)

    def test_generic_witnesses_get_no_discount(self):
        """97, 101, 251 cost more than the larger perfect powers 81, 243."""
        for generic in (97, 101, 251):
            n_generic, _ = shortest_am_chain(generic, cap=9)
            n_power, _ = shortest_am_chain(243, cap=9)
            self.assertGreaterEqual(n_generic, n_power)
        self.assertEqual(shortest_am_chain(81, cap=9)[0], 4)
        self.assertEqual(shortest_am_chain(97, cap=9)[0], 6)   # smaller, dearer

    def test_known_false_control_multiplication_always_helps(self):
        """'multiplication strictly shortens every witness' must fire."""
        ties = [r for r in (3, 5, 7, 11)
                if shortest_am_chain(r, cap=6)[0] == binary_addition_length(r)]
        self.assertTrue(ties, "the false rule must have counterexamples")
        self.assertIn(3, ties)
        self.assertIn(5, ties)
        self.assertIn(7, ties)     # 7 costs 4 either way

    def test_rejections_and_shape(self):
        c = compare(3, 4)
        self.assertIsInstance(c, CostComparison)
        with self.assertRaises(Exception):
            c.saving = 0
        with self.assertRaises(ValueError):
            binary_addition_chain(0)
        with self.assertRaises(ValueError):
            power_chain(1, 3)
        with self.assertRaises(ValueError):
            shortest_am_chain(0)
        self.assertFalse(is_valid_chain([1, 5], allow_multiplication=True))
        self.assertFalse(is_valid_chain([2, 4], allow_multiplication=True))


if __name__ == "__main__":
    unittest.main()
