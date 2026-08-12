#!/usr/bin/env python3

import unittest

from higher_arity_cancellation import (
    collision_family,
    form_higher_cancellation,
    pairwise_ledger,
    proper_context_ledger,
    strict_hierarchy_family,
)


class HigherArityCancellationTests(unittest.TestCase):
    def test_odd_prime_unbounded_same_pairwise_ledger(self):
        for prime in (3, 5, 7, 11):
            ledgers = set()
            for height in range(1, 7):
                inputs = collision_family(prime, height)
                ledgers.add(pairwise_ledger(inputs, prime))
                formed = form_higher_cancellation(inputs, prime)
                self.assertEqual(formed.cancellation, height)
                self.assertEqual(len(formed.steps), height + 1)
            self.assertEqual(ledgers, {(0, 0, 0, 0, 0, 0)})

    def test_two_adic_unbounded_same_pairwise_ledger(self):
        ledgers = set()
        for height in range(2, 9):
            inputs = collision_family(2, height)
            ledgers.add(pairwise_ledger(inputs, 2))
            self.assertEqual(form_higher_cancellation(inputs, 2).cancellation, height)
        self.assertEqual(ledgers, {(0, 0, 1, 1, 0, 0)})

    def test_common_scaling_equivariance(self):
        inputs = (1, 1, 79)
        base = form_higher_cancellation(inputs, 3).cancellation
        for scale in (-45, 2, 7, 81):
            scaled = tuple(scale * value for value in inputs)
            self.assertEqual(form_higher_cancellation(scaled, 3).cancellation, base)

    def test_first_nonzero_residue_is_minimal_depth_witness(self):
        formed = form_higher_cancellation((9, 18, 216), 3)
        self.assertEqual(formed.common_depth, 2)
        self.assertEqual(formed.cancellation, 3)
        self.assertTrue(all(step.sum_residue == 0 for step in formed.steps[:-1]))
        self.assertNotEqual(formed.steps[-1].sum_residue, 0)

    def test_zero_sum_is_separately_typed(self):
        formed = form_higher_cancellation((2, 3, -5), 5)
        self.assertTrue(formed.is_zero_sum)
        self.assertIsNone(formed.cancellation)
        self.assertEqual(formed.steps, ())

    def test_pairwise_zero_sum_and_bad_arity_fail_closed(self):
        with self.assertRaises(ValueError):
            pairwise_ledger((1, -1, 2), 3)
        with self.assertRaises(ValueError):
            form_higher_cancellation((1,), 3)

    def test_strict_hierarchy_at_every_tested_arity_and_prime(self):
        for prime in (2, 3, 5, 7):
            for arity in range(2, 8):
                start = 1
                while True:
                    try:
                        strict_hierarchy_family(prime, arity, start)
                        break
                    except ValueError:
                        start += 1
                ledgers = set()
                for height in range(start, start + 4):
                    inputs = strict_hierarchy_family(prime, arity, height)
                    ledgers.add(proper_context_ledger(inputs, prime))
                    self.assertEqual(
                        form_higher_cancellation(inputs, prime).cancellation,
                        height,
                    )
                self.assertEqual(len(ledgers), 1)

    def test_strict_hierarchy_rejects_unstable_or_nonpositive_range(self):
        with self.assertRaises(ValueError):
            strict_hierarchy_family(2, 5, 2)
        with self.assertRaises(ValueError):
            strict_hierarchy_family(3, 1, 4)


if __name__ == "__main__":
    unittest.main()
