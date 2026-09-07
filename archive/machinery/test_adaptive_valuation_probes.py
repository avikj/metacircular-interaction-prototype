#!/usr/bin/env python3

import unittest
from functools import lru_cache

from adaptive_valuation_probes import (
    identify_residue,
    verify_adaptive_certificate,
    worst_case_residue,
)
from valuation_future_residue import truncated_valuation


def exact_minimax(prime, depth):
    modulus = prime**depth
    responses = tuple(
        tuple(truncated_valuation(r - c, prime, depth) for r in range(modulus))
        for c in range(modulus)
    )

    @lru_cache(None)
    def solve(states):
        if len(states) <= 1:
            return 0
        best = modulus + 1
        for center in range(modulus):
            parts = {}
            for state in states:
                parts.setdefault(responses[center][state], []).append(state)
            if len(parts) == 1:
                continue
            best = min(best, 1 + max(solve(tuple(part)) for part in parts.values()))
        return best

    return solve(tuple(range(modulus)))


class AdaptiveValuationProbeTests(unittest.TestCase):
    def test_every_residue_is_reconstructed_within_bound(self):
        for prime, depth in ((2, 5), (3, 3), (5, 2)):
            for residue in range(prime**depth):
                certificate = identify_residue(residue, prime, depth)
                self.assertEqual(certificate.residue, residue)
                self.assertLessEqual(len(certificate.steps), depth * (prime - 1))
                self.assertTrue(verify_adaptive_certificate(certificate))

    def test_all_last_digits_attain_bound(self):
        for prime, depth in ((2, 6), (3, 4), (5, 3)):
            certificate = identify_residue(worst_case_residue(prime, depth), prime, depth)
            self.assertEqual(len(certificate.steps), depth * (prime - 1))

    def test_exact_minimax_falsifier_matches_formula(self):
        for prime, depth in ((2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (5, 1)):
            self.assertEqual(exact_minimax(prime, depth), depth * (prime - 1))

    def test_tampered_and_invalid_certificates_fail_closed(self):
        certificate = identify_residue(17, 3, 3)
        self.assertFalse(
            verify_adaptive_certificate(
                type(certificate)(3, 3, 16, certificate.steps)
            )
        )
        with self.assertRaises(ValueError):
            identify_residue(1, 9, 2)


if __name__ == "__main__":
    unittest.main()
