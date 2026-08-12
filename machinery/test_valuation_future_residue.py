#!/usr/bin/env python3

import unittest

from valuation_future_residue import (
    future_signature,
    noncongruence_control,
    pair_profile,
    reconstruct_residue,
    restricted_class_count,
    restricted_meaning,
    restricted_signature,
    truncated_valuation,
)


class ValuationFutureResidueTests(unittest.TestCase):
    def test_future_behavior_reconstructs_every_residue(self):
        for prime, depth in ((2, 4), (3, 3), (5, 2)):
            for residue in range(prime**depth):
                signature = future_signature(residue, prime, depth)
                self.assertEqual(reconstruct_residue(signature, prime, depth), residue)

    def test_signatures_are_pairwise_distinct(self):
        for prime, depth in ((2, 3), (3, 2), (5, 2)):
            signatures = {
                future_signature(residue, prime, depth)
                for residue in range(prime**depth)
            }
            self.assertEqual(len(signatures), prime**depth)

    def test_profile_equivalence_is_not_append_congruence(self):
        for prime in (2, 3, 5, 7, 11):
            control = noncongruence_control(prime)
            self.assertEqual(
                pair_profile(control.left, prime, control.depth),
                pair_profile(control.right, prime, control.depth),
            )
            left_total = sum(control.left) + control.continuation
            right_total = sum(control.right) + control.continuation
            self.assertNotEqual(
                truncated_valuation(left_total, prime, control.depth),
                truncated_valuation(right_total, prime, control.depth),
            )

    def test_common_unit_scaling_is_not_complete_equivalence(self):
        # First coordinate 1 forces a common multiplier to be 1 modulo m.
        control = noncongruence_control(5)
        self.assertEqual(pair_profile(control.left, 5, 2), pair_profile(control.right, 5, 2))
        self.assertNotEqual(control.left[1] % 25, control.right[1] % 25)

    def test_malformed_signatures_fail_closed(self):
        with self.assertRaises(ValueError):
            reconstruct_residue((0, 1), 3, 2)
        lawful = list(future_signature(1, 3, 2))
        lawful[0] = 2
        with self.assertRaises(ValueError):
            reconstruct_residue(tuple(lawful), 3, 2)
        with self.assertRaises(ValueError):
            future_signature(1, 9, 1)

    def test_restricted_closed_form_matches_literal_behaviors(self):
        for prime, depth in ((2, 4), (3, 3), (5, 2)):
            modulus = prime**depth
            for action_depth in range(depth + 1):
                by_signature = {}
                by_meaning = {}
                for residue in range(modulus):
                    by_signature.setdefault(
                        restricted_signature(residue, prime, depth, action_depth), []
                    ).append(residue)
                    by_meaning.setdefault(
                        restricted_meaning(residue, prime, depth, action_depth), []
                    ).append(residue)
                self.assertEqual(sorted(by_signature.values()), sorted(by_meaning.values()))
                self.assertEqual(
                    len(by_signature),
                    restricted_class_count(prime, depth, action_depth),
                )

    def test_one_new_valuation_layer_splits_exactly_one_stratum(self):
        prime, depth = 3, 4
        for action_depth in range(1, depth + 1):
            old = {}
            new = {}
            for residue in range(prime**depth):
                old.setdefault(restricted_meaning(residue, prime, depth, action_depth), []).append(residue)
                new.setdefault(restricted_meaning(residue, prime, depth, action_depth - 1), []).append(residue)
            unchanged = [
                block for label, block in old.items()
                if label != ("depth", action_depth - 1)
            ]
            for block in unchanged:
                self.assertIn(block, new.values())
            split = old[("depth", action_depth - 1)]
            self.assertTrue(all([residue] in new.values() for residue in split))

    def test_restricted_endpoints(self):
        self.assertEqual(restricted_class_count(3, 4, 0), 81)
        self.assertEqual(restricted_class_count(3, 4, 4), 5)
        with self.assertRaises(ValueError):
            restricted_signature(1, 3, 2, 3)


if __name__ == "__main__":
    unittest.main()
