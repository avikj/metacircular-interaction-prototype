#!/usr/bin/env python3
"""Exact checks for `notes/WITNESS_RADIUS_STAIRCASE.md`.

The predictions are checked against `relative_depth`, which is a literal
evaluation of the corpus definition of `D_S(x)` and shares no code with the
profile computation.
"""

from __future__ import annotations

import itertools
import unittest

from witness_radius_staircase import (
    INFINITY,
    ambient_depth,
    canonical_staircase,
    displacement_order,
    observed_staircase,
    poly,
    predicted_staircase,
    relative_depth,
    truncated_valuation,
    valuation,
    witness_classes,
    witness_radius,
)


def instances():
    """Small polynomials with a finite, workable `e = v_p(f(x))`."""
    for prime in (2, 3, 5):
        for coeffs in itertools.product(range(-3, 4), repeat=3):
            if all(c == 0 for c in coeffs):
                continue
            for x in range(-4, 5):
                f = poly(coeffs)
                value = f(x)
                if value == 0:
                    continue
                e = valuation(value, prime)
                if e > 4:
                    continue
                yield prime, coeffs, x, e


class Locality(unittest.TestCase):
    def test_truncated_valuation_is_a_function_of_the_residue(self):
        """Lemma 1.1: `min(v_p(f(y)), e+1)` depends only on `y mod p^(e+1)`."""
        for prime, coeffs, x, e in itertools.islice(instances(), 0, None, 7):
            f = poly(coeffs)
            modulus = prime ** (e + 1)
            for r in range(modulus):
                base = truncated_valuation(f, r, prime, e)
                for shift in (1, 2, -1):
                    self.assertEqual(
                        base,
                        truncated_valuation(f, r + shift * modulus, prime, e),
                        (prime, coeffs, x, e, r, shift))

    def test_witnesses_are_never_deeper_than_e(self):
        """Cap: `v_p(y-x) >= e+1` forces agreement, so `D_S(x) <= e+1`."""
        for prime, coeffs, x, e in instances():
            radii = witness_radius(poly(coeffs), x, prime, e)
            self.assertEqual(len(radii), e + 1)
            self.assertLessEqual(ambient_depth(poly(coeffs), x, prime, e), e + 1)

    def test_ambient_depth_matches_the_oracle(self):
        """`1 + max{j : m_j finite}` equals `D_S(x)` for a full residue system."""
        for prime, coeffs, x, e in instances():
            f = poly(coeffs)
            width = prime ** (e + 1)
            world = range(x - width, x + width + 1)
            self.assertEqual(ambient_depth(f, x, prime, e),
                             relative_depth(f, world, x, prime, e + 2),
                             (prime, coeffs, x, e))


class Staircase(unittest.TestCase):
    def test_prediction_matches_the_oracle_in_displacement_order(self):
        """Theorem 2.2, checked against a literal `D_S(x)` evaluation."""
        for prime, coeffs, x, e in instances():
            f = poly(coeffs)
            radii = witness_radius(f, x, prime, e)
            order = displacement_order(x, prime ** (e + 1))
            self.assertEqual(predicted_staircase(radii),
                             observed_staircase(f, order, x, prime, e + 2),
                             (prime, coeffs, x, e, radii))

    def test_visited_depths_are_a_subsequence_of_the_realized_levels(self):
        """Theorem 2.1(i): every order visits a subset of `{j+1 : m_j finite}`."""
        for prime, coeffs, x, e in itertools.islice(instances(), 0, None, 5):
            f = poly(coeffs)
            radii = witness_radius(f, x, prime, e)
            allowed = {0} | {j + 1 for j, m in enumerate(radii)
                             if m != INFINITY}
            width = prime ** (e + 1)
            for order in (displacement_order(x, width),
                          list(range(x - width, x + width + 1)),
                          list(range(x + width, x - width - 1, -1))):
                for depth in observed_staircase(f, order, x, prime, e + 2):
                    self.assertIn(depth, allowed, (prime, coeffs, x, e))

    def test_depth_is_monotone_along_any_order(self):
        for prime, coeffs, x, e in itertools.islice(instances(), 0, None, 11):
            f = poly(coeffs)
            observed = observed_staircase(
                f, displacement_order(x, prime ** (e + 1)), x, prime, e + 2)
            self.assertEqual(observed, sorted(observed))


class TranslatedInstance(unittest.TestCase):
    """The instance separating the two natural orders (Theorem 3.1)."""

    def test_full_staircase_in_displacement_order(self):
        for prime, e in ((2, 4), (3, 3), (5, 2)):
            f = poly([prime ** e, 1])
            radii = witness_radius(f, 0, prime, e)
            self.assertEqual(radii, [prime ** j for j in range(e + 1)])
            self.assertEqual(predicted_staircase(radii), list(range(e + 2)))
            self.assertEqual(
                observed_staircase(f, displacement_order(0, prime ** (e + 1)),
                                   0, prime, e + 2),
                list(range(e + 2)))

    def test_one_step_in_the_canonical_filtration(self):
        """`claude_arithmetic_breaker`'s Theorem S, reproduced exactly."""
        for prime, e in ((2, 4), (3, 3), (5, 2)):
            self.assertEqual(
                canonical_staircase(poly([0, 1]), prime ** e, prime,
                                    prime ** (e + 1), e + 2),
                [e, e + 1])


class PermanentMiss(unittest.TestCase):
    """Proposition 4.1: a multiplicatively generated world never stabilizes."""

    def test_powers_of_two_never_meet_the_witness_class(self):
        prime, f, x = 7, poly([-3, 1]), 1
        e = valuation(f(x), prime)
        self.assertEqual(e, 0)
        self.assertEqual(sorted(witness_classes(f, prime, e)), [3])
        self.assertEqual(ambient_depth(f, x, prime, e), 1)
        world = [x] + [pow(2, k) for k in range(1, 400)]
        self.assertEqual(relative_depth(f, world, x, prime, e + 2), 0)


class WitnessSet(unittest.TestCase):
    def test_witness_classes_agree_with_pointwise_membership(self):
        for prime, coeffs, x, e in itertools.islice(instances(), 0, None, 9):
            f = poly(coeffs)
            modulus = prime ** (e + 1)
            classes = witness_classes(f, prime, e)
            for y in range(-2 * modulus, 2 * modulus):
                self.assertEqual(
                    truncated_valuation(f, y, prime, e) != e,
                    y % modulus in classes,
                    (prime, coeffs, x, e, y))


if __name__ == "__main__":
    unittest.main(verbosity=2)
